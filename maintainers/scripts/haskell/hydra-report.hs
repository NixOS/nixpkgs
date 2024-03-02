#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: [p.aeson p.req])"
#! nix-shell -p hydra-unstable
#! nix-shell -i runhaskell

{-

The purpose of this script is

1) download the state of the nixpkgs/haskell-updates job from hydra (with get-report)
2) print a summary of the state suitable for pasting into a github comment (with ping-maintainers)
3) print a list of broken packages suitable for pasting into configuration-hackage2nix.yaml

Because step 1) is quite expensive and takes roughly ~5 minutes the result is cached in a json file in XDG_CACHE.

-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DataKinds #-}

import Control.Monad (forM_, forM, (<=<))
import Control.Monad.Trans (MonadIO (liftIO))
import Data.Aeson (
   FromJSON,
   FromJSONKey,
   ToJSON,
   decodeFileStrict',
   eitherDecodeStrict',
   encodeFile,
 )
import Data.Foldable (Foldable (toList), foldl')
import Data.List.NonEmpty (NonEmpty, nonEmpty)
import qualified Data.List.NonEmpty as NonEmpty
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Maybe (fromMaybe, mapMaybe, isNothing)
import Data.Monoid (Sum (Sum, getSum))
import Data.Sequence (Seq)
import qualified Data.Sequence as Seq
import Data.Set (Set)
import qualified Data.Set as Set
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)
import qualified Data.Text.IO as Text
import Data.Time (defaultTimeLocale, formatTime, getCurrentTime)
import Data.Time.Clock (UTCTime)
import GHC.Generics (Generic)
import Network.HTTP.Req (
    GET (GET),
    HttpResponse (HttpResponseBody),
    NoReqBody (NoReqBody),
    Option,
    Req,
    Scheme (Https),
    bsResponse,
    defaultHttpConfig,
    header,
    https,
    jsonResponse,
    req,
    responseBody,
    responseTimeout,
    runReq,
    (/:),
 )
import System.Directory (XdgDirectory (XdgCache), getXdgDirectory)
import System.Environment (getArgs)
import System.Process (readProcess)
import Prelude hiding (id)
import Data.List (sortOn)
import Control.Concurrent.Async (concurrently)
import Control.Exception (evaluate)
import qualified Data.IntMap.Strict as IntMap
import qualified Data.IntSet as IntSet
import Data.Bifunctor (second)
import Data.Data (Proxy)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as ByteString
import Distribution.Simple.Utils (safeLast, fromUTF8BS)

newtype JobsetEvals = JobsetEvals
   { evals :: Seq Eval
   }
   deriving stock (Generic, Show)
   deriving anyclass (ToJSON, FromJSON)

newtype Nixpkgs = Nixpkgs {revision :: Text}
   deriving stock (Generic, Show)
   deriving anyclass (ToJSON, FromJSON)

newtype JobsetEvalInputs = JobsetEvalInputs {nixpkgs :: Nixpkgs}
   deriving stock (Generic, Show)
   deriving anyclass (ToJSON, FromJSON)

data Eval = Eval
   { id :: Int
   , jobsetevalinputs :: JobsetEvalInputs
   , builds :: Seq Int
   }
   deriving (Generic, ToJSON, FromJSON, Show)

-- | Hydra job name.
--
-- Examples:
-- - @"haskellPackages.lens.x86_64-linux"@
-- - @"haskell.packages.ghc925.cabal-install.aarch64-darwin"@
-- - @"pkgsMusl.haskell.compiler.ghc90.x86_64-linux"@
-- - @"arion.aarch64-linux"@
newtype JobName = JobName { unJobName :: Text }
   deriving stock (Generic, Show)
   deriving newtype (Eq, FromJSONKey, FromJSON, Ord, ToJSON)

-- | Datatype representing the result of querying the build evals of the
-- haskell-updates Hydra jobset.
--
-- The URL <https://hydra.nixos.org/eval/EVAL_ID/builds> (where @EVAL_ID@ is a
-- value like 1792418) returns a list of 'Build'.
data Build = Build
   { job :: JobName
   , buildstatus :: Maybe Int
     -- ^ Status of the build.  See 'getBuildState' for the meaning of each state.
   , finished :: Int
     -- ^ Whether or not the build is finished.  @0@ if finished, non-zero otherwise.
   , id :: Int
   , nixname :: Text
     -- ^ Nix name of the derivation.
     --
     -- Examples:
     -- - @"lens-5.2.1"@
     -- - @"cabal-install-3.8.0.1"@
     -- - @"lens-static-x86_64-unknown-linux-musl-5.1.1"@
   , system :: Text
     -- ^ System
     --
     -- Examples:
     -- - @"x86_64-linux"@
     -- - @"aarch64-darwin"@
   , jobsetevals :: Seq Int
   }
   deriving (Generic, ToJSON, FromJSON, Show)

data HydraSlownessWorkaroundFlag = HydraSlownessWorkaround | NoHydraSlownessWorkaround
data RequestLogsFlag = RequestLogs | NoRequestLogs

main :: IO ()
main = do
   args <- getArgs
   case args of
      ["get-report", "--slow"] -> getBuildReports HydraSlownessWorkaround
      ["get-report"] -> getBuildReports NoHydraSlownessWorkaround
      ["ping-maintainers"] -> printMaintainerPing
      ["mark-broken-list", "--no-request-logs"] -> printMarkBrokenList NoRequestLogs
      ["mark-broken-list"] -> printMarkBrokenList RequestLogs
      ["eval-info"] -> printEvalInfo
      _ -> putStrLn "Usage: get-report [--slow] | ping-maintainers | mark-broken-list [--no-request-logs] | eval-info"

reportFileName :: IO FilePath
reportFileName = getXdgDirectory XdgCache "haskell-updates-build-report.json"

showT :: Show a => a -> Text
showT = Text.pack . show

getBuildReports :: HydraSlownessWorkaroundFlag -> IO ()
getBuildReports opt = runReq defaultHttpConfig do
   evalMay <- Seq.lookup 0 . evals <$> hydraJSONQuery mempty ["jobset", "nixpkgs", "haskell-updates", "evals"]
   eval@Eval{id} <- maybe (liftIO $ fail "No Evaluation found") pure evalMay
   liftIO . putStrLn $ "Fetching evaluation " <> show id <> " from Hydra. This might take a few minutes..."
   buildReports <- getEvalBuilds opt id
   liftIO do
      fileName <- reportFileName
      putStrLn $ "Finished fetching all builds from Hydra, saving report as " <> fileName
      now <- getCurrentTime
      encodeFile fileName (eval, now, buildReports)

getEvalBuilds :: HydraSlownessWorkaroundFlag -> Int -> Req (Seq Build)
getEvalBuilds NoHydraSlownessWorkaround id =
  hydraJSONQuery mempty ["eval", showT id, "builds"]
getEvalBuilds HydraSlownessWorkaround id = do
  Eval{builds} <- hydraJSONQuery mempty [ "eval", showT id ]
  forM builds $ \buildId -> do
    liftIO $ putStrLn $ "Querying build " <> show buildId
    hydraJSONQuery mempty [ "build", showT buildId ]

hydraQuery :: HttpResponse a => Proxy a -> Option 'Https -> [Text] -> Req (HttpResponseBody a)
hydraQuery responseType option query = do
  let customHeaderOpt =
        header
          "User-Agent"
          "hydra-report.hs/v1 (nixpkgs;maintainers/scripts/haskell) pls fix https://github.com/NixOS/nixos-org-configurations/issues/270"
      customTimeoutOpt = responseTimeout 900_000_000 -- 15 minutes
      opts = customHeaderOpt <> customTimeoutOpt <> option
      url = foldl' (/:) (https "hydra.nixos.org") query
  responseBody <$> req GET url NoReqBody responseType opts

hydraJSONQuery :: FromJSON a => Option 'Https -> [Text] -> Req a
hydraJSONQuery = hydraQuery jsonResponse

hydraPlainQuery :: [Text] -> Req ByteString
hydraPlainQuery = hydraQuery bsResponse mempty

hydraEvalCommand :: FilePath
hydraEvalCommand = "hydra-eval-jobs"

hydraEvalParams :: [String]
hydraEvalParams = ["-I", ".", "pkgs/top-level/release-haskell.nix"]

nixExprCommand :: FilePath
nixExprCommand = "nix-instantiate"

nixExprParams :: [String]
nixExprParams = ["--eval", "--strict", "--json"]

-- | This newtype is used to parse a Hydra job output from @hydra-eval-jobs@.
-- The only field we are interested in is @maintainers@, which is why this
-- is just a newtype.
--
-- Note that there are occasionally jobs that don't have a maintainers
-- field, which is why this has to be @Maybe Text@.
newtype Maintainers = Maintainers { maintainers :: Maybe Text }
  deriving stock (Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

-- | This is a 'Map' from Hydra job name to maintainer email addresses.
--
-- It has values similar to the following:
--
-- @@
--  fromList
--    [ ("arion.aarch64-linux", Maintainers (Just "robert@example.com"))
--    , ("bench.x86_64-linux", Maintainers (Just ""))
--    , ("conduit.x86_64-linux", Maintainers (Just "snoy@man.com, web@ber.com"))
--    , ("lens.x86_64-darwin", Maintainers (Just "ek@category.com"))
--    ]
-- @@
--
-- Note that Hydra jobs without maintainers will have an empty string for the
-- maintainer list.
type HydraJobs = Map JobName Maintainers

-- | Map of email addresses to GitHub handles.
-- This is built from the file @../../maintainer-list.nix@.
--
-- It has values similar to the following:
--
-- @@
--  fromList
--    [ ("robert@example.com", "rob22")
--    , ("ek@category.com", "edkm")
--    ]
-- @@
type EmailToGitHubHandles = Map Text Text

-- | Map of Hydra jobs to maintainer GitHub handles.
--
-- It has values similar to the following:
--
-- @@
--  fromList
--    [ ("arion.aarch64-linux", ["rob22"])
--    , ("conduit.x86_64-darwin", ["snoyb", "webber"])
--    ]
-- @@
type MaintainerMap = Map JobName (NonEmpty Text)

-- | Information about a package which lists its dependencies and whether the
-- package is marked broken.
data DepInfo = DepInfo {
   deps :: Set PkgName,
   broken :: Bool
}
   deriving stock (Generic, Show)
   deriving anyclass (FromJSON, ToJSON)

-- | Map from package names to their DepInfo. This is the data we get out of a
-- nix call.
type DependencyMap = Map PkgName DepInfo

-- | Map from package names to its broken state, number of reverse dependencies (fst) and
-- unbroken reverse dependencies (snd).
type ReverseDependencyMap = Map PkgName (Int, Int)

-- | Calculate the (unbroken) reverse dependencies of a package by transitively
-- going through all packages if it’s a dependency of them.
calculateReverseDependencies :: DependencyMap -> ReverseDependencyMap
calculateReverseDependencies depMap =
   Map.fromDistinctAscList $ zip keys (zip (rdepMap False) (rdepMap True))
 where
    -- This code tries to efficiently invert the dependency map and calculate
    -- it’s transitive closure by internally identifying every pkg with it’s index
    -- in the package list and then using memoization.
    keys :: [PkgName]
    keys = Map.keys depMap

    pkgToIndexMap :: Map PkgName Int
    pkgToIndexMap = Map.fromDistinctAscList (zip keys [0..])

    depInfos :: [DepInfo]
    depInfos = Map.elems depMap

    depInfoToIdx :: DepInfo -> (Bool, [Int])
    depInfoToIdx DepInfo{broken,deps} =
       (broken, mapMaybe (`Map.lookup` pkgToIndexMap) $ Set.toList deps)

    intDeps :: [(Int, (Bool, [Int]))]
    intDeps = zip [0..] (fmap depInfoToIdx depInfos)

    rdepMap onlyUnbroken = IntSet.size <$> resultList
     where
       resultList = go <$> [0..]
       oneStepMap = IntMap.fromListWith IntSet.union $ (\(key,(_,deps)) -> (,IntSet.singleton key) <$> deps) <=< filter (\(_, (broken,_)) -> not (broken && onlyUnbroken)) $ intDeps
       go pkg = IntSet.unions (oneStep:((resultList !!) <$> IntSet.toList oneStep))
        where oneStep = IntMap.findWithDefault mempty pkg oneStepMap

-- | Generate a mapping of Hydra job names to maintainer GitHub handles. Calls
-- hydra-eval-jobs and the nix script ./maintainer-handles.nix.
getMaintainerMap :: IO MaintainerMap
getMaintainerMap = do
   hydraJobs :: HydraJobs <-
      readJSONProcess hydraEvalCommand hydraEvalParams "Failed to decode hydra-eval-jobs output: "
   handlesMap :: EmailToGitHubHandles <-
      readJSONProcess nixExprCommand ("maintainers/scripts/haskell/maintainer-handles.nix":nixExprParams) "Failed to decode nix output for lookup of github handles: "
   pure $ Map.mapMaybe (splitMaintainersToGitHubHandles handlesMap) hydraJobs
  where
   -- Split a comma-spearated string of Maintainers into a NonEmpty list of
   -- GitHub handles.
   splitMaintainersToGitHubHandles
      :: EmailToGitHubHandles -> Maintainers -> Maybe (NonEmpty Text)
   splitMaintainersToGitHubHandles handlesMap (Maintainers maint) =
      nonEmpty .  mapMaybe (`Map.lookup` handlesMap) .  Text.splitOn ", " $ fromMaybe "" maint

-- | Get the a map of all dependencies of every package by calling the nix
-- script ./dependencies.nix.
getDependencyMap :: IO DependencyMap
getDependencyMap =
   readJSONProcess
      nixExprCommand
      ("maintainers/scripts/haskell/dependencies.nix" : nixExprParams)
      "Failed to decode nix output for lookup of dependencies: "

-- | Run a process that produces JSON on stdout and and decode the JSON to a
-- data type.
--
-- If the JSON-decoding fails, throw the JSON-decoding error.
readJSONProcess
   :: FromJSON a
   => FilePath -- ^ Filename of executable.
   -> [String] -- ^ Arguments
   -> String -- ^ String to prefix to JSON-decode error.
   -> IO a
readJSONProcess exe args err = do
   output <- readProcess exe args ""
   let eitherDecodedOutput = eitherDecodeStrict' . encodeUtf8 . Text.pack $ output
   case eitherDecodedOutput of
     Left decodeErr -> error $ err <> decodeErr <> "\nRaw: '" <> take 1000 output <> "'"
     Right decodedOutput -> pure decodedOutput

-- BuildStates are sorted by subjective importance/concerningness
data BuildState
  = Failed
  | DependencyFailed
  | OutputLimitExceeded
  | Unknown (Maybe Int)
  | TimedOut
  | Canceled
  | HydraFailure
  | Unfinished
  | Success
  deriving stock (Show, Eq, Ord)

icon :: BuildState -> Text
icon = \case
   Failed -> "❌"
   DependencyFailed -> "❗"
   OutputLimitExceeded -> "⚠️"
   Unknown x -> "unknown code " <> showT x
   TimedOut -> "⌛🚫"
   Canceled -> "🚫"
   Unfinished -> "⏳"
   HydraFailure -> "🚧"
   Success -> "✅"

platformIcon :: Platform -> Text
platformIcon (Platform x) = case x of
   "x86_64-linux" -> "🐧"
   "aarch64-linux" -> "📱"
   "x86_64-darwin" -> "🍎"
   "aarch64-darwin" -> "🍏"
   _ -> x

platformIsOS :: OS -> Platform -> Bool
platformIsOS os (Platform x) = case (os, x) of
   (Linux, "x86_64-linux") -> True
   (Linux, "aarch64-linux") -> True
   (Darwin, "x86_64-darwin") -> True
   (Darwin, "aarch64-darwin") -> True
   _ -> False


-- | A package name.  This is parsed from a 'JobName'.
--
-- Examples:
--
-- - The 'JobName' @"haskellPackages.lens.x86_64-linux"@ produces the 'PkgName'
--   @"lens"@.
-- - The 'JobName' @"haskell.packages.ghc925.cabal-install.aarch64-darwin"@
--   produces the 'PkgName' @"cabal-install"@.
-- - The 'JobName' @"pkgsMusl.haskell.compiler.ghc90.x86_64-linux"@ produces
--   the 'PkgName' @"ghc90"@.
-- - The 'JobName' @"arion.aarch64-linux"@ produces the 'PkgName' @"arion"@.
--
-- 'PkgName' is also used as a key in 'DependencyMap' and 'ReverseDependencyMap'.
-- In this case, 'PkgName' originally comes from attribute names in @haskellPackages@
-- in Nixpkgs.
newtype PkgName = PkgName Text
   deriving stock (Generic, Show)
   deriving newtype (Eq, FromJSON, FromJSONKey, Ord, ToJSON)

-- | A package set name.  This is parsed from a 'JobName'.
--
-- Examples:
--
-- - The 'JobName' @"haskellPackages.lens.x86_64-linux"@ produces the 'PkgSet'
--   @"haskellPackages"@.
-- - The 'JobName' @"haskell.packages.ghc925.cabal-install.aarch64-darwin"@
--   produces the 'PkgSet' @"haskell.packages.ghc925"@.
-- - The 'JobName' @"pkgsMusl.haskell.compiler.ghc90.x86_64-linux"@ produces
--   the 'PkgSet' @"pkgsMusl.haskell.compiler"@.
-- - The 'JobName' @"arion.aarch64-linux"@ produces the 'PkgSet' @""@.
--
-- As you can see from the last example, 'PkgSet' can be empty (@""@) for
-- top-level jobs.
newtype PkgSet = PkgSet Text
   deriving stock (Generic, Show)
   deriving newtype (Eq, FromJSON, FromJSONKey, Ord, ToJSON)

data BuildResult = BuildResult {state :: BuildState, id :: Int} deriving (Show, Eq, Ord)
newtype Platform = Platform {platform :: Text} deriving (Show, Eq, Ord)
data SummaryEntry = SummaryEntry {
   summaryBuilds :: Table PkgSet Platform BuildResult,
   summaryMaintainers :: Set Text,
   summaryReverseDeps :: Int,
   summaryUnbrokenReverseDeps :: Int
}
type StatusSummary = Map PkgName SummaryEntry

data OS = Linux | Darwin

newtype Table row col a = Table (Map (row, col) a)

singletonTable :: row -> col -> a -> Table row col a
singletonTable row col a = Table $ Map.singleton (row, col) a

unionTable :: (Ord row, Ord col) => Table row col a -> Table row col a -> Table row col a
unionTable (Table l) (Table r) = Table $ Map.union l r

filterWithKeyTable :: (row -> col -> a -> Bool) -> Table row col a -> Table row col a
filterWithKeyTable f (Table t) = Table $ Map.filterWithKey (\(r,c) a -> f r c a) t

nullTable :: Table row col a -> Bool
nullTable (Table t) = Map.null t

instance (Ord row, Ord col, Semigroup a) => Semigroup (Table row col a) where
   Table l <> Table r = Table (Map.unionWith (<>) l r)
instance (Ord row, Ord col, Semigroup a) => Monoid (Table row col a) where
   mempty = Table Map.empty
instance Functor (Table row col) where
   fmap f (Table a) = Table (fmap f a)
instance Foldable (Table row col) where
   foldMap f (Table a) = foldMap f a

getBuildState :: Build -> BuildState
getBuildState Build{finished, buildstatus} = case (finished, buildstatus) of
   (0, _) -> Unfinished
   (_, Just 0) -> Success
   (_, Just 1) -> Failed
   (_, Just 2) -> DependencyFailed
   (_, Just 3) -> HydraFailure
   (_, Just 4) -> Canceled
   (_, Just 7) -> TimedOut
   (_, Just 11) -> OutputLimitExceeded
   (_, i) -> Unknown i

combineStatusSummaries :: Seq StatusSummary -> StatusSummary
combineStatusSummaries = foldl (Map.unionWith unionSummary) Map.empty
  where
   unionSummary :: SummaryEntry -> SummaryEntry -> SummaryEntry
   unionSummary (SummaryEntry lb lm lr lu) (SummaryEntry rb rm rr ru) =
      SummaryEntry (unionTable lb rb) (lm <> rm) (max lr rr) (max lu ru)

buildToPkgNameAndSet :: Build -> (PkgName, PkgSet)
buildToPkgNameAndSet Build{job = JobName jobName, system} = (name, set)
  where
   packageName :: Text
   packageName = fromMaybe jobName (Text.stripSuffix ("." <> system) jobName)

   splitted :: Maybe (NonEmpty Text)
   splitted = nonEmpty $ Text.splitOn "." packageName

   name :: PkgName
   name = PkgName $ maybe packageName NonEmpty.last splitted

   set :: PkgSet
   set = PkgSet $ maybe "" (Text.intercalate "." . NonEmpty.init) splitted

buildToStatusSummary :: MaintainerMap -> ReverseDependencyMap -> Build -> StatusSummary
buildToStatusSummary maintainerMap reverseDependencyMap build@Build{job, id, system} =
   Map.singleton pkgName summaryEntry
  where
   (pkgName, pkgSet) = buildToPkgNameAndSet build

   maintainers :: Set Text
   maintainers = maybe mempty (Set.fromList . toList) (Map.lookup job maintainerMap)

   (reverseDeps, unbrokenReverseDeps) =
      Map.findWithDefault (0,0) pkgName reverseDependencyMap

   buildTable :: Table PkgSet Platform BuildResult
   buildTable =
      singletonTable pkgSet (Platform system) (BuildResult (getBuildState build) id)

   summaryEntry = SummaryEntry buildTable maintainers reverseDeps unbrokenReverseDeps

readBuildReports :: IO (Eval, UTCTime, Seq Build)
readBuildReports = do
   file <- reportFileName
   fromMaybe (error $ "Could not decode " <> file) <$> decodeFileStrict' file

sep :: Text
sep = " | "
joinTable :: [Text] -> Text
joinTable t = sep <> Text.intercalate sep t <> sep

type NumSummary = Table Platform BuildState Int

printTable :: (Ord rows, Ord cols) => Text -> (rows -> Text) -> (cols -> Text) -> (entries -> Text) -> Table rows cols entries -> [Text]
printTable name showR showC showE (Table mapping) = joinTable <$> (name : map showC cols) : replicate (length cols + sepsInName + 1) "---" : map printRow rows
  where
   sepsInName = Text.count "|" name
   printRow row = showR row : map (\col -> maybe "" showE (Map.lookup (row, col) mapping)) cols
   rows = toList $ Set.fromList (fst <$> Map.keys mapping)
   cols = toList $ Set.fromList (snd <$> Map.keys mapping)

printJob :: Int -> PkgName -> (Table PkgSet Platform BuildResult, Text) -> [Text]
printJob evalId (PkgName name) (Table mapping, maintainers) =
   if length sets <= 1
      then map printSingleRow sets
      else ["- [ ] " <> makeJobSearchLink (PkgSet "") name <> " " <> maintainers] <> map printRow sets
  where
   printRow :: PkgSet -> Text
   printRow (PkgSet set) =
      "  - " <> printState (PkgSet set) <> " " <>
      makeJobSearchLink (PkgSet set) (if Text.null set then "toplevel" else set)

   printSingleRow set =
      "- [ ] " <> printState set <> " " <>
      makeJobSearchLink set (makePkgName set) <> " " <> maintainers

   makePkgName :: PkgSet -> Text
   makePkgName (PkgSet set) = (if Text.null set then "" else set <> ".") <> name

   printState set =
      Text.intercalate " " $ map (\pf -> maybe "" (label pf) $ Map.lookup (set, pf) mapping) platforms

   makeJobSearchLink :: PkgSet -> Text -> Text
   makeJobSearchLink set linkLabel = makeSearchLink evalId linkLabel (makePkgName set)

   sets :: [PkgSet]
   sets = toList $ Set.fromList (fst <$> Map.keys mapping)

   platforms :: [Platform]
   platforms = toList $ Set.fromList (snd <$> Map.keys mapping)

   label pf (BuildResult s i) = "[[" <> platformIcon pf <> icon s <> "]](https://hydra.nixos.org/build/" <> showT i <> ")"

makeSearchLink :: Int -> Text -> Text -> Text
makeSearchLink evalId linkLabel query = "[" <> linkLabel <> "](" <> "https://hydra.nixos.org/eval/" <> showT evalId <> "?filter=" <> query <> ")"

statusToNumSummary :: StatusSummary -> NumSummary
statusToNumSummary = fmap getSum . foldMap (fmap Sum . jobTotals)

jobTotals :: SummaryEntry -> Table Platform BuildState Int
jobTotals (summaryBuilds -> Table mapping) = getSum <$> Table (Map.foldMapWithKey (\(_, platform) (BuildResult buildstate _) -> Map.singleton (platform, buildstate) (Sum 1)) mapping)

details :: Text -> [Text] -> [Text]
details summary content = ["<details><summary>" <> summary <> " </summary>", ""] <> content <> ["</details>", ""]

evalLine :: Eval -> UTCTime -> Text
evalLine Eval{id, jobsetevalinputs = JobsetEvalInputs{nixpkgs = Nixpkgs{revision}}} fetchTime =
   "*evaluation ["
    <> showT id
    <> "](https://hydra.nixos.org/eval/"
    <> showT id
    <> ") of nixpkgs commit ["
    <> Text.take 7 revision
    <> "](https://github.com/NixOS/nixpkgs/commits/"
    <> revision
    <> ") as of "
    <> Text.pack (formatTime defaultTimeLocale "%Y-%m-%d %H:%M UTC" fetchTime)
    <> "*"

printBuildSummary :: Eval -> UTCTime -> StatusSummary -> [(PkgName, Int)] -> Text
printBuildSummary eval@Eval{id} fetchTime summary topBrokenRdeps =
   Text.unlines $
      headline <> [""] <> tldr <> (("  * "<>) <$> (errors <> warnings)) <> [""]
         <> totals
         <> optionalList "#### Maintained Linux packages with build failure" (maintainedList (fails summaryLinux))
         <> optionalList "#### Maintained Linux packages with failed dependency" (maintainedList (failedDeps summaryLinux))
         <> optionalList "#### Maintained Linux packages with unknown error" (maintainedList (unknownErr summaryLinux))
         <> optionalHideableList "#### Maintained Darwin packages with build failure" (maintainedList (fails summaryDarwin))
         <> optionalHideableList "#### Maintained Darwin packages with failed dependency" (maintainedList (failedDeps summaryDarwin))
         <> optionalHideableList "#### Maintained Darwin packages with unknown error" (maintainedList (unknownErr summaryDarwin))
         <> optionalHideableList "#### Unmaintained packages with build failure" (unmaintainedList (fails summary))
         <> optionalHideableList "#### Unmaintained packages with failed dependency" (unmaintainedList (failedDeps summary))
         <> optionalHideableList "#### Unmaintained packages with unknown error" (unmaintainedList (unknownErr summary))
         <> optionalHideableList "#### Top 50 broken packages, sorted by number of reverse dependencies" (brokenLine <$> topBrokenRdeps)
         <> ["","*⤴️: The number of packages that depend (directly or indirectly) on this package (if any). If two numbers are shown the first (lower) number considers only packages which currently have enabled hydra jobs, i.e. are not marked broken. The second (higher) number considers all packages.*",""]
         <> footer
  where
   footer = ["*Report generated with [maintainers/scripts/haskell/hydra-report.hs](https://github.com/NixOS/nixpkgs/blob/haskell-updates/maintainers/scripts/haskell/hydra-report.hs)*"]

   headline =
      [ "### [haskell-updates build report from hydra](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates)"
      , evalLine eval fetchTime
      ]

   totals :: [Text]
   totals =
      [ "#### Build summary"
      , ""
      ] <>
      printTable
         "Platform"
         (\x -> makeSearchLink id (platform x <> " " <> platformIcon x) ("." <> platform x))
         (\x -> showT x <> " " <> icon x)
         showT
         numSummary

   brokenLine :: (PkgName, Int) -> Text
   brokenLine (PkgName name, rdeps) =
      "[" <> name <> "](https://packdeps.haskellers.com/reverse/" <> name <>
      ") ⤴️ " <> Text.pack (show rdeps) <> "  "

   numSummary = statusToNumSummary summary

   summaryLinux :: StatusSummary
   summaryLinux = withOS Linux summary

   summaryDarwin :: StatusSummary
   summaryDarwin = withOS Darwin summary

   -- Remove all BuildResult from the Table that have Platform that isn't for
   -- the given OS.
   tableForOS :: OS -> Table PkgSet Platform BuildResult -> Table PkgSet Platform BuildResult
   tableForOS os = filterWithKeyTable (\_ platform _ -> platformIsOS os platform)

   -- Remove all BuildResult from the StatusSummary that have a Platform that
   -- isn't for the given OS.  Completely remove all PkgName from StatusSummary
   -- that end up with no BuildResults.
   withOS
      :: OS
      -> StatusSummary
      -> StatusSummary
   withOS os =
      Map.mapMaybe
         (\e@SummaryEntry{summaryBuilds} ->
            let buildsForOS = tableForOS os summaryBuilds
            in if nullTable buildsForOS then Nothing else Just e { summaryBuilds = buildsForOS }
         )

   jobsByState :: (BuildState -> Bool) -> StatusSummary -> StatusSummary
   jobsByState predicate = Map.filter (predicate . worstState)

   worstState :: SummaryEntry -> BuildState
   worstState = foldl' min Success . fmap state . summaryBuilds

   fails :: StatusSummary -> StatusSummary
   fails = jobsByState (== Failed)

   failedDeps :: StatusSummary -> StatusSummary
   failedDeps = jobsByState (== DependencyFailed)

   unknownErr :: StatusSummary -> StatusSummary
   unknownErr = jobsByState (\x -> x > DependencyFailed && x < TimedOut)

   withMaintainer :: StatusSummary -> Map PkgName (Table PkgSet Platform BuildResult, NonEmpty Text)
   withMaintainer =
      Map.mapMaybe
         (\e -> (summaryBuilds e,) <$> nonEmpty (Set.toList (summaryMaintainers e)))

   withoutMaintainer :: StatusSummary -> StatusSummary
   withoutMaintainer = Map.mapMaybe (\e -> if Set.null (summaryMaintainers e) then Just e else Nothing)

   optionalList :: Text -> [Text] -> [Text]
   optionalList heading list = if null list then mempty else [heading] <> list

   optionalHideableList :: Text -> [Text] -> [Text]
   optionalHideableList heading list = if null list then mempty else [heading] <> details (showT (length list) <> " job(s)") list

   maintainedList :: StatusSummary -> [Text]
   maintainedList = showMaintainedBuild <=< Map.toList . withMaintainer

   summaryEntryGetReverseDeps :: SummaryEntry -> (Int, Int)
   summaryEntryGetReverseDeps sumEntry =
      ( negate $ summaryUnbrokenReverseDeps sumEntry
      , negate $ summaryReverseDeps sumEntry
      )

   sortOnReverseDeps :: [(PkgName, SummaryEntry)] -> [(PkgName, SummaryEntry)]
   sortOnReverseDeps = sortOn (\(_, sumEntry) -> summaryEntryGetReverseDeps sumEntry)

   unmaintainedList :: StatusSummary -> [Text]
   unmaintainedList = showBuild <=< sortOnReverseDeps . Map.toList . withoutMaintainer

   showBuild :: (PkgName, SummaryEntry) -> [Text]
   showBuild (name, entry) =
      printJob
         id
         name
         ( summaryBuilds entry
         , Text.pack
            ( if summaryReverseDeps entry > 0
               then
                  " ⤴️ " <> show (summaryUnbrokenReverseDeps entry) <>
                  " | " <> show (summaryReverseDeps entry)
               else ""
            )
         )

   showMaintainedBuild
      :: (PkgName, (Table PkgSet Platform BuildResult, NonEmpty Text)) -> [Text]
   showMaintainedBuild (name, (table, maintainers)) =
      printJob
         id
         name
         ( table
         , Text.intercalate " " (fmap ("@" <>) (toList maintainers))
         )

   tldr = case (errors, warnings) of
            ([],[]) -> ["🟢 **Ready to merge** (if there are no [evaluation errors](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates))"]
            ([],_) -> ["🟡 **Potential issues** (and possibly [evaluation errors](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates))"]
            _ -> ["🔴 **Branch not mergeable**"]
   warnings =
      if' (Unfinished > maybe Success worstState maintainedJob) "`maintained` jobset failed." <>
      if' (Unfinished == maybe Success worstState mergeableJob) "`mergeable` jobset is not finished." <>
      if' (Unfinished == maybe Success worstState maintainedJob) "`maintained` jobset is not finished."
   errors =
      if' (isNothing mergeableJob) "No `mergeable` job found." <>
      if' (isNothing maintainedJob) "No `maintained` job found." <>
      if' (Unfinished > maybe Success worstState mergeableJob) "`mergeable` jobset failed." <>
      if' (outstandingJobs (Platform "x86_64-linux") > 100) "Too many outstanding jobs on x86_64-linux." <>
      if' (outstandingJobs (Platform "aarch64-linux") > 100) "Too many outstanding jobs on aarch64-linux."

   if' p e = if p then [e] else mempty

   outstandingJobs platform | Table m <- numSummary = Map.findWithDefault 0 (platform, Unfinished) m

   maintainedJob = Map.lookup (PkgName "maintained") summary
   mergeableJob = Map.lookup (PkgName "mergeable") summary

printEvalInfo :: IO ()
printEvalInfo = do
   (eval, fetchTime, _) <- readBuildReports
   putStrLn (Text.unpack $ evalLine eval fetchTime)

printMaintainerPing :: IO ()
printMaintainerPing = do
   (maintainerMap, (reverseDependencyMap, topBrokenRdeps)) <- concurrently getMaintainerMap do
      depMap <- getDependencyMap
      rdepMap <- evaluate . calculateReverseDependencies $ depMap
      let tops = take 50 . sortOn (negate . snd) . fmap (second fst) . filter (\x -> maybe False broken $ Map.lookup (fst x) depMap) . Map.toList $ rdepMap
      pure (rdepMap, tops)
   (eval, fetchTime, buildReport) <- readBuildReports
   let statusSummaries =
          fmap (buildToStatusSummary maintainerMap reverseDependencyMap) buildReport
       buildSum :: StatusSummary
       buildSum = combineStatusSummaries statusSummaries
       textBuildSummary = printBuildSummary eval fetchTime buildSum topBrokenRdeps
   Text.putStrLn textBuildSummary

printMarkBrokenList :: RequestLogsFlag -> IO ()
printMarkBrokenList reqLogs = do
   (_, fetchTime, buildReport) <- readBuildReports
   runReq defaultHttpConfig $ forM_ buildReport \build@Build{job, id} ->
      case (getBuildState build, Text.splitOn "." $ unJobName job) of
         (Failed, ["haskellPackages", name, "x86_64-linux"]) -> do
            -- We use the last probable error cause found in the build log file.
            error_message <- fromMaybe "failure" <$>
              case reqLogs of
                NoRequestLogs -> pure Nothing
                RequestLogs -> do
                  -- Fetch build log from hydra to figure out the cause of the error.
                  build_log <- ByteString.lines <$> hydraPlainQuery ["build", showT id, "nixlog", "1", "raw"]
                  pure $ safeLast $ mapMaybe probableErrorCause build_log
            liftIO $ putStrLn $ "  - " <> Text.unpack name <> " # " <> error_message <> " in job https://hydra.nixos.org/build/" <> show id <> " at " <> formatTime defaultTimeLocale "%Y-%m-%d" fetchTime
         _ -> pure ()

{- | This function receives a line from a Nix Haskell builder build log and returns a possible error cause.
 | We might need to add other causes in the future if errors happen in unusual parts of the builder.
-}
probableErrorCause :: ByteString -> Maybe String
probableErrorCause "Setup: Encountered missing or private dependencies:" = Just "dependency missing"
probableErrorCause "running tests" = Just "test failure"
probableErrorCause build_line | ByteString.isPrefixOf "Building" build_line = Just ("failure building " <> fromUTF8BS (fst $ ByteString.breakSubstring " for" $ ByteString.drop 9 build_line))
probableErrorCause build_line | ByteString.isSuffixOf "Phase" build_line = Just ("failure in " <> fromUTF8BS build_line)
probableErrorCause _ = Nothing
