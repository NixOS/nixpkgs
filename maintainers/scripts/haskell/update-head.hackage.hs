#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: with p; [aeson optparse-applicative])"
#! nix-shell -p git
#! nix-shell -p nix-prefetch-git
#! nix-shell -p nixfmt
#! nix-shell -i runhaskell


{-

This is largely copied from the generate-nix-overrides.hs script in the
head.hackage repo.

-}

{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

import           Control.Monad
import           Data.Aeson
import qualified Data.ByteString.Char8         as BS8
import           Data.List
import qualified Data.Map                      as Map
import           Data.Ord
import           Distribution.Package
import           Distribution.Text
import           Distribution.Version
import           GHC.Generics                   ( Generic )
import           Options.Applicative
import           System.Directory
import           System.Environment
import           System.FilePath
import           System.Process                 ( readProcess )

groupPatches :: Ord a => [(a, k)] -> [(a, [k])]
groupPatches assocs =
  Map.toAscList $ Map.fromListWith (++) [ (k, [v]) | (k, v) <- assocs ]

generateOverrides :: FilePath -> FilePath -> IO String
generateOverrides prefix patchDir = do
  patches         <- listDirectory patchDir
  override_groups <- groupPatches <$> mapM
    (generateOverride prefix)
    (groupPatches [ (dropExtension pf, decidePatchType pf) | pf <- patches ])
  let overrides = map mkOverride override_groups
  return $ intercalate "\n" overrides

mkOverride :: (PackageName, [([Int], String)]) -> String
mkOverride (display -> pName, patches) =
  unlines
    $  [unwords [pName, "= if", superPname, "== null then", superPname]]
    ++ packages
    ++ ["else", superPname, ";"]
 where
  superPname = "super." ++ pName
  quotes s = "\"" ++ s ++ "\""
  packages :: [String]
  packages = map mkPackages (sortBy (comparing fst) patches)
  mkPackages (version, patch) = unwords
    [ "else if"
    , superPname ++ ".version == "
    , quotes (intercalate "." (map show version))
    , " then ("
    , patch
    , ")"
    ]

override :: FilePath -> FilePath -> String -> PatchType -> String
override prefix extlessPath nixexpr ptype = unwords
  [ "("
  , patchFunction ptype
  , quote (prefix </> addExtension extlessPath (patchTypeExt ptype))
  , nixexpr
  , ")"
  ]

generateOverride
  :: FilePath -> (FilePath, [PatchType]) -> IO (PackageName, ([Int], String))
generateOverride prefix (patchExtless, patchTypes) = do
  let pid' :: Maybe PackageId = simpleParse (takeFileName patchExtless)
  pid <- maybe (fail ("invalid patch file name: " ++ show patchExtless))
               return
               pid'
  let pname   = display (packageName pid)
      version = versionNumbers (packageVersion pid)
  return
    .  (packageName pid, )
    .  (version        , )
    $  "haskellLib.doJailbreak (dontRevise "
    ++ foldl' (override prefix patchExtless) ("super." ++ pname) patchTypes
    ++ ")"

patchFunction :: PatchType -> String
patchFunction = \case
  CabalPatch  -> "setCabalFile"
  NormalPatch -> "haskellLib.appendPatch"

patchTypeExt :: PatchType -> String
patchTypeExt = \case
  CabalPatch  -> ".cabal"
  NormalPatch -> ".patch"

decidePatchType :: FilePath -> PatchType
decidePatchType patch = case takeExtension patch of
  ".cabal" -> CabalPatch
  ".patch" -> NormalPatch
  _        -> error $ "Unexpected patch extension: " ++ patch

data PatchType = CabalPatch | NormalPatch deriving Eq

quote :: String -> String
quote x = "\"" <> x <> "\""

data PrefetchOutput = PrefetchOutput
  { sha256 :: String
  , path   :: String
  , rev    :: String
  , date   :: String
  }
  deriving (Generic, FromJSON)

main :: IO ()
main = join . customExecParser (prefs showHelpOnError) $ info
  (helper <*> parser)
  (  fullDesc
  <> header "update-head.hackage"
  <> progDesc
       "Fetch the latest version of head.hackage and update configuration-head.hackage.nix"
  )
 where
  parser :: Parser (IO ())
  parser =
    main'
      <$> switch (long "do-commit" <> help "commit the updated file to git")
      <*> strOption
            (  long "repo"
            <> metavar "URL"
            <> help "head.hackage repo"
            <> value "https://gitlab.haskell.org/ghc/head.hackage/"
            <> showDefault
            )
      <*> optional
            (strOption
              (long "rev" <> metavar "REV" <> help
                "specific revision to update to"
              )
            )

main' :: Bool -> String -> Maybe String -> IO ()
main' doCommit url desiredRev = do
  let config =
        "pkgs/development/haskell-modules/configuration-head.hackage.nix"

  let revFlags = maybe [] (\r -> ["--rev", r]) desiredRev
  Just PrefetchOutput {..} <- decodeStrict . BS8.pack <$> readProcess
    "nix-prefetch-git"
    ([url] <> revFlags)
    ""

  overrides <- generateOverrides "${head-hackage-src}/patches"
                                 (path </> "patches")

  let
    configString = unlines
      [ "# This file has been automatically generated by"
      , "# maintainers/scripts/haskell/update-head.hackage.hs"
      , ""
      , "{pkgs, haskellLib}:"
      , "let"
      , "  # head-hackage-version = " <> quote (take 10 date) <> ";"
      , "  head-hackage-src = pkgs.fetchgit {"
      , "    url = " <> quote url <> ";"
      , "    rev = " <> quote rev <> ";"
      , "    sha256 = " <> quote sha256 <> ";"
      , "  };"
      , "  dontRevise = haskellLib.overrideCabal (old: { editedCabalFile = null; });"
      , "  setCabalFile = file: haskellLib.overrideCabal (old: { postPatch = ''cp ${file} ${old.pname}.cabal''; });"
      , "in"
      , "self: super: {\n"
      , overrides
      , "}"
      ]

  formatted <- readProcess "nixfmt" [] configString

  if doCommit
    then do
      oldVersion <- head . lines <$> readProcess
        "sed"
        [ "-n"
        , "-e"
        , "s/.*head-hackage-version = \"\\([^\"]*\\)\";/\\1/p"
        , config
        ]
        ""
      writeFile config formatted
      let
        message = unlines
          [ "configuration-head.hackage: " <> oldVersion <> " -> " <> take 10 date
          , ""
          , "This commit has been generated by maintainers/scripts/haskell/update-head.hackage.hs"
          ]
      readProcess "git" ["commit", config, "--message", message] ""
      pure ()
    else writeFile config formatted

