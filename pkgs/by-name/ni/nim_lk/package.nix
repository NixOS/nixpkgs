{ lib, buildPackages, nim2Packages, fetchFromSourcehut, openssl }:

nim2Packages.buildNimPackage (finalAttrs: {
  pname = "nim_lk";
  version = "20231031";
  nimBinOnly = true;

  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_lk";
    rev = finalAttrs.version;
    hash = "sha256-dXm3dfXAxgucek19f1KdRShOsJyELPTB32qgGSKId6A=";
  };

  buildInputs = [ openssl ];

  nimFlags = finalAttrs.passthru.nimFlagsFromLockFile ./lock.json;

  meta = finalAttrs.src.meta // {
    description = "Generate Nix specific lock files for Nim packages";
    homepage = "https://git.sr.ht/~ehmry/nim_lk";
    mainProgram = "nim_lk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ehmry ];
  };

  passthru.nimFlagsFromLockFile = let
    fetchDependency = let
      methods = {
        fetchzip = { url, sha256, ... }:
          buildPackages.fetchzip {
            name = "source";
            inherit url sha256;
          };
        git = { fetchSubmodules, leaveDotGit, rev, sha256, url, ... }:
          buildPackages.fetchgit {
            inherit fetchSubmodules leaveDotGit rev sha256 url;
          };
      };
    in attrs@{ method, ... }: methods.${method} attrs // attrs;
  in lockFile:
  with builtins;
  lib.pipe lockFile [
    readFile
    fromJSON
    (getAttr "depends")
    (map fetchDependency)
    (map ({ outPath, srcDir, ... }: ''--path:"${outPath}/${srcDir}"''))
  ];

})
