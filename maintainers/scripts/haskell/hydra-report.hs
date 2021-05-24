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
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TupleSections #-}
{-# OPTIONS_GHC -Wall #-}

import Control.Monad (forM_, (<=<))
import Control.Monad.Trans (MonadIO (liftIO))
import Data.Aeson (
   FromJSON,
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
import Data.Maybe (fromMaybe, mapMaybe)
import Data.Monoid (Sum (Sum, getSum))
import Data.Sequence (Seq)
import qualified Data.Sequence as Seq
import Data.Set (Set)
import qualified Data.Set as Set
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)
import Data.Time (defaultTimeLocale, formatTime, getCurrentTime)
import Data.Time.Clock (UTCTime)
import GHC.Generics (Generic)
import Network.HTTP.Req (
   GET (GET),
   NoReqBody (NoReqBody),
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

newtype JobsetEvals = JobsetEvals
   { evals :: Seq Eval
   }
   deriving (Generic, ToJSON, FromJSON, Show)

newtype Nixpkgs = Nixpkgs {revision :: Text}
   deriving (Generic, ToJSON, FromJSON, Show)

newtype JobsetEvalInputs = JobsetEvalInputs {nixpkgs :: Nixpkgs}
   deriving (Generic, ToJSON, FromJSON, Show)

data Eval = Eval
   { id :: Int
   , jobsetevalinputs :: JobsetEvalInputs
   }
   deriving (Generic, ToJSON, FromJSON, Show)

data Build = Build
   { job :: Text
   , buildstatus :: Maybe Int
   , finished :: Int
   , id :: Int
   , nixname :: Text
   , system :: Text
   , jobsetevals :: Seq Int
   }
   deriving (Generic, ToJSON, FromJSON, Show)

main :: IO ()
main = do
   args <- getArgs
   case args of
      ["get-report"] -> getBuildReports
      ["ping-maintainers"] -> printMaintainerPing
      ["mark-broken-list"] -> printMarkBrokenList
      _ -> putStrLn "Usage: get-report | ping-maintainers | mark-broken-list"

reportFileName :: IO FilePath
reportFileName = getXdgDirectory XdgCache "haskell-updates-build-report.json"

showT :: Show a => a -> Text
showT = Text.pack . show

getBuildReports :: IO ()
getBuildReports = runReq defaultHttpConfig do
   evalMay <- Seq.lookup 0 . evals <$> myReq (https "hydra.nixos.org" /: "jobset" /: "nixpkgs" /: "haskell-updates" /: "evals") mempty
   eval@Eval{id} <- maybe (liftIO $ fail "No Evalution found") pure evalMay
   liftIO . putStrLn $ "Fetching evaluation " <> show id <> " from Hydra. This might take a few minutes..."
   buildReports :: Seq Build <- myReq (https "hydra.nixos.org" /: "eval" /: showT id /: "builds") (responseTimeout 600000000)
   liftIO do
      fileName <- reportFileName
      putStrLn $ "Finished fetching all builds from Hydra, saving report as " <> fileName
      now <- getCurrentTime
      encodeFile fileName (eval, now, buildReports)
  where
   myReq query option = responseBody <$> req GET query NoReqBody jsonResponse (header "User-Agent" "hydra-report.hs/v1 (nixpkgs;maintainers/scripts/haskell)" <> option)

hydraEvalCommand :: FilePath
hydraEvalCommand = "hydra-eval-jobs"

hydraEvalParams :: [String]
hydraEvalParams = ["-I", ".", "pkgs/top-level/release-haskell.nix"]

handlesCommand :: FilePath
handlesCommand = "nix-instantiate"

handlesParams :: [String]
handlesParams = ["--eval", "--strict", "--json", "-"]

handlesExpression :: String
handlesExpression = "with import ./. {}; with lib; zipAttrsWith (_: builtins.head) (mapAttrsToList (_: v: if v ? github then { \"${v.email}\" = v.github; } else {}) (import maintainers/maintainer-list.nix))"

-- | This newtype is used to parse a Hydra job output from @hydra-eval-jobs@.
-- The only field we are interested in is @maintainers@, which is why this
-- is just a newtype.
--
-- Note that there are occassionally jobs that don't have a maintainers
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
type HydraJobs = Map Text Maintainers

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
type MaintainerMap = Map Text (NonEmpty Text)

-- | Generate a mapping of Hydra job names to maintainer GitHub handles.
getMaintainerMap :: IO MaintainerMap
getMaintainerMap = do
   hydraJobs :: HydraJobs <-
      readJSONProcess hydraEvalCommand hydraEvalParams "" "Failed to decode hydra-eval-jobs output: "
   handlesMap :: EmailToGitHubHandles <-
      readJSONProcess handlesCommand handlesParams handlesExpression "Failed to decode nix output for lookup of github handles: "
   pure $ Map.mapMaybe (splitMaintainersToGitHubHandles handlesMap) hydraJobs
   where
   -- Split a comma-spearated string of Maintainers into a NonEmpty list of
   -- GitHub handles.
   splitMaintainersToGitHubHandles
      :: EmailToGitHubHandles -> Maintainers -> Maybe (NonEmpty Text)
   splitMaintainersToGitHubHandles handlesMap (Maintainers maint) =
      nonEmpty .  mapMaybe (`Map.lookup` handlesMap) .  Text.splitOn ", " $ fromMaybe "" maint

-- | Run a process that produces JSON on stdout and and decode the JSON to a
-- data type.
--
-- If the JSON-decoding fails, throw the JSON-decoding error.
readJSONProcess
   :: FromJSON a
   => FilePath -- ^ Filename of executable.
   -> [String] -- ^ Arguments
   -> String -- ^ stdin to pass to the process
   -> String -- ^ String to prefix to JSON-decode error.
   -> IO a
readJSONProcess exe args input err = do
   output <- readProcess exe args input
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
   Failed -> ":x:"
   DependencyFailed -> ":heavy_exclamation_mark:"
   OutputLimitExceeded -> ":warning:"
   Unknown x -> "unknown code " <> showT x
   TimedOut -> ":hourglass::no_entry_sign:"
   Canceled -> ":no_entry_sign:"
   Unfinished -> ":hourglass_flowing_sand:"
   HydraFailure -> ":construction:"
   Success -> ":heavy_check_mark:"

platformIcon :: Platform -> Text
platformIcon (Platform x) = case x of
   "x86_64-linux" -> ":penguin:"
   "aarch64-linux" -> ":iphone:"
   "x86_64-darwin" -> ":apple:"
   _ -> x

data BuildResult = BuildResult {state :: BuildState, id :: Int} deriving (Show, Eq, Ord)
newtype Platform = Platform {platform :: Text} deriving (Show, Eq, Ord)
newtype Table row col a = Table (Map (row, col) a)
type StatusSummary = Map Text (Table Text Platform BuildResult, Set Text)

instance (Ord row, Ord col, Semigroup a) => Semigroup (Table row col a) where
   Table l <> Table r = Table (Map.unionWith (<>) l r)
instance (Ord row, Ord col, Semigroup a) => Monoid (Table row col a) where
   mempty = Table Map.empty
instance Functor (Table row col) where
   fmap f (Table a) = Table (fmap f a)
instance Foldable (Table row col) where
   foldMap f (Table a) = foldMap f a

buildSummary :: MaintainerMap -> Seq Build -> StatusSummary
buildSummary maintainerMap = foldl (Map.unionWith unionSummary) Map.empty . fmap toSummary
  where
   unionSummary (Table l, l') (Table r, r') = (Table $ Map.union l r, l' <> r')
   toSummary Build{finished, buildstatus, job, id, system} = Map.singleton name (Table (Map.singleton (set, Platform system) (BuildResult state id)), maintainers)
     where
      state :: BuildState
      state = case (finished, buildstatus) of
         (0, _) -> Unfinished
         (_, Just 0) -> Success
         (_, Just 1) -> Failed
         (_, Just 2) -> DependencyFailed
         (_, Just 3) -> HydraFailure
         (_, Just 4) -> Canceled
         (_, Just 7) -> TimedOut
         (_, Just 11) -> OutputLimitExceeded
         (_, i) -> Unknown i
      packageName = fromMaybe job (Text.stripSuffix ("." <> system) job)
      splitted = nonEmpty $ Text.splitOn "." packageName
      name = maybe packageName NonEmpty.last splitted
      set = maybe "" (Text.intercalate "." . NonEmpty.init) splitted
      maintainers = maybe mempty (Set.fromList . toList) (Map.lookup job maintainerMap)

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

printJob :: Int -> Text -> (Table Text Platform BuildResult, Text) -> [Text]
printJob evalId name (Table mapping, maintainers) =
   if length sets <= 1
      then map printSingleRow sets
      else ["- [ ] " <> makeJobSearchLink "" name <> " " <> maintainers] <> map printRow sets
  where
   printRow set = "  - " <> printState set <> " " <> makeJobSearchLink set (if Text.null set then "toplevel" else set)
   printSingleRow set = "- [ ] " <> printState set <> " " <> makeJobSearchLink set (makePkgName set) <> " " <> maintainers
   makePkgName set = (if Text.null set then "" else set <> ".") <> name
   printState set = Text.intercalate " " $ map (\pf -> maybe "" (label pf) $ Map.lookup (set, pf) mapping) platforms
   makeJobSearchLink set linkLabel= makeSearchLink evalId linkLabel (makePkgName set)
   sets = toList $ Set.fromList (fst <$> Map.keys mapping)
   platforms = toList $ Set.fromList (snd <$> Map.keys mapping)
   label pf (BuildResult s i) = "[[" <> platformIcon pf <> icon s <> "]](https://hydra.nixos.org/build/" <> showT i <> ")"

makeSearchLink :: Int -> Text -> Text -> Text
makeSearchLink evalId linkLabel query = "[" <> linkLabel <> "](" <> "https://hydra.nixos.org/eval/" <> showT evalId <> "?filter=" <> query <> ")"

statusToNumSummary :: StatusSummary -> NumSummary
statusToNumSummary = fmap getSum . foldMap (fmap Sum . jobTotals)

jobTotals :: (Table Text Platform BuildResult, a) -> Table Platform BuildState Int
jobTotals (Table mapping, _) = getSum <$> Table (Map.foldMapWithKey (\(_, platform) (BuildResult buildstate _) -> Map.singleton (platform, buildstate) (Sum 1)) mapping)

details :: Text -> [Text] -> [Text]
details summary content = ["<details><summary>" <> summary <> " </summary>", ""] <> content <> ["</details>", ""]

printBuildSummary :: Eval -> UTCTime -> StatusSummary -> Text
printBuildSummary
   Eval{id, jobsetevalinputs = JobsetEvalInputs{nixpkgs = Nixpkgs{revision}}}
   fetchTime
   summary =
      Text.unlines $
         headline <> totals
            <> optionalList "#### Maintained packages with build failure" (maintainedList fails)
            <> optionalList "#### Maintained packages with failed dependency" (maintainedList failedDeps)
            <> optionalList "#### Maintained packages with unknown error" (maintainedList unknownErr)
            <> optionalHideableList "#### Unmaintained packages with build failure" (unmaintainedList fails)
            <> optionalHideableList "#### Unmaintained packages with failed dependency" (unmaintainedList failedDeps)
            <> optionalHideableList "#### Unmaintained packages with unknown error" (unmaintainedList unknownErr)
            <> footer
     where
      footer = ["*Report generated with [maintainers/scripts/haskell/hydra-report.hs](https://github.com/NixOS/nixpkgs/blob/haskell-updates/maintainers/scripts/haskell/hydra-report.sh)*"]
      totals =
         [ "#### Build summary"
         , ""
         ]
            <> printTable "Platform" (\x -> makeSearchLink id (platform x <> " " <> platformIcon x) ("." <> platform x)) (\x -> showT x <> " " <> icon x) showT (statusToNumSummary summary)
      headline =
         [ "### [haskell-updates build report from hydra](https://hydra.nixos.org/jobset/nixpkgs/haskell-updates)"
         , "*evaluation ["
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
         ]
      jobsByState predicate = Map.filter (predicate . foldl' min Success . fmap state . fst) summary
      fails = jobsByState (== Failed)
      failedDeps = jobsByState (== DependencyFailed)
      unknownErr = jobsByState (\x -> x > DependencyFailed && x < TimedOut)
      withMaintainer = Map.mapMaybe (\(x, m) -> (x,) <$> nonEmpty (Set.toList m))
      withoutMaintainer = Map.mapMaybe (\(x, m) -> if Set.null m then Just x else Nothing)
      optionalList heading list = if null list then mempty else [heading] <> list
      optionalHideableList heading list = if null list then mempty else [heading] <> details (showT (length list) <> " job(s)") list
      maintainedList = showMaintainedBuild <=< Map.toList . withMaintainer
      unmaintainedList = showBuild <=< Map.toList . withoutMaintainer
      showBuild (name, table) = printJob id name (table, "")
      showMaintainedBuild (name, (table, maintainers)) = printJob id name (table, Text.intercalate " " (fmap ("@" <>) (toList maintainers)))

printMaintainerPing :: IO ()
printMaintainerPing = do
   maintainerMap <- getMaintainerMap
   (eval, fetchTime, buildReport) <- readBuildReports
   putStrLn (Text.unpack (printBuildSummary eval fetchTime (buildSummary maintainerMap buildReport)))

printMarkBrokenList :: IO ()
printMarkBrokenList = do
   (_, _, buildReport) <- readBuildReports
   forM_ buildReport \Build{buildstatus, job} ->
      case (buildstatus, Text.splitOn "." job) of
         (Just 1, ["haskellPackages", name, "x86_64-linux"]) -> putStrLn $ "  - " <> Text.unpack name
         _ -> pure ()
