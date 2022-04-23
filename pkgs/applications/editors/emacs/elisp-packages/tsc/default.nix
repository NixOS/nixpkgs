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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "emacs-tree-sitter";
    repo = "elisp-tree-sitter";
    rev = version;
    sha256 = "sha256-tAohHdAsy/HTFFPSNOo0UyrdolH8h0KF2ekFXuLltBE=";
  };

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

    nativeBuildInputs = [ clang ];
    sourceRoot = "source/core";

    configurePhase = ''
      export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
    '';

    postInstall = ''
      LIB=($out/lib/libtsc_dyn.*)
      TSC_PATH=$out/share/emacs/site-lisp/elpa/tsc-${version}
      install -d $TSC_PATH
      install -m444 $out/lib/libtsc_dyn.* $TSC_PATH/''${LIB/*libtsc_/tsc-}
      echo -n $version > $TSC_PATH/DYN-VERSION
      rm -r $out/lib
    '';

    cargoSha256 = "sha256-7UOhs3wx6fGvqPjNxUKoEHwPtiJ5zgLFPwDSvhYlmis=";
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
