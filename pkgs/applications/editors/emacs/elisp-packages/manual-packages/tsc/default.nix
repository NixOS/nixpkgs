{ lib
, symlinkJoin
, melpaBuild
, fetchFromGitHub
, rustPlatform
, writeText
, clang
, llvmPackages

, runtimeShell
, writeScript
, python3
, nix-prefetch-github
, nix
}:

let

  srcMeta = lib.importJSON ./src.json;
  inherit (srcMeta) version;

  src = fetchFromGitHub srcMeta.src;

  tsc = melpaBuild {
    inherit src;
    inherit version;

    pname = "tsc";
    commit = version;

    sourceRoot = "source/core";

    recipe = writeText "recipe" ''
      (tsc
      :repo "emacs-tree-sitter/elisp-tree-sitter"
      :fetcher github)
    '';
  };

  tsc-dyn = rustPlatform.buildRustPackage {
    inherit version;
    inherit src;

    pname = "tsc-dyn";

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    sourceRoot = "source/core";

    postInstall = ''
      LIB=($out/lib/libtsc_dyn.*)
      TSC_PATH=$out/share/emacs/site-lisp/elpa/tsc-${version}
      install -d $TSC_PATH
      install -m444 $out/lib/libtsc_dyn.* $TSC_PATH/''${LIB/*libtsc_/tsc-}
      echo -n $version > $TSC_PATH/DYN-VERSION
      rm -r $out/lib
    '';

    inherit (srcMeta) cargoSha256;
  };

in symlinkJoin {
  name = "tsc-${version}";
  paths = [ tsc tsc-dyn ];

  passthru = {
    updateScript = let
      pythonEnv = python3.withPackages(ps: [ ps.requests ]);
    in writeScript "tsc-update" ''
      #!${runtimeShell}
      set -euo pipefail
      export PATH=${lib.makeBinPath [
        nix-prefetch-github
        nix
        pythonEnv
      ]}:$PATH
      exec python3 ${builtins.toString ./update.py} ${builtins.toString ./.}
    '';
  };

  meta = {
    description = "The core APIs of the Emacs binding for tree-sitter.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pimeys ];
  };
}
