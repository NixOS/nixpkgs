# NOTE: Tests related to getElfFiles go here.
{
  emptyDirectory,
  emptyFile,
  getElfFiles,
  hello,
  lib,
  pkgsStatic,
  stdenv,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testEqualArrayOrMap;

  check =
    {
      name,
      searchPaths,
      elfFiles,
    }:
    (testEqualArrayOrMap {
      inherit name;
      valuesArray = searchPaths;
      expectedArray = elfFiles;
      script = ''
        set -eu
        nixLog "running getElfFiles with ''${valuesArray[@]@Q} to populate actualArray"
        getElfFiles actualArray "''${valuesArray[@]}"
      '';
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ getElfFiles ];
        meta = prevAttrs.meta or { } // {
          platforms = lib.platforms.linux;
        };
      });

  checkWithExistingGoodbye =
    args:
    (check args).overrideAttrs (prevAttrs: {
      script =
        ''
          nixLog "appending goodbye to actualArray"
          actualArray+=("goodbye")
        ''
        + prevAttrs.script;
    });

in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "getElfFiles";
    src = ./getElfFiles.bash;
  };

  shfmt = shfmt {
    name = "getElfFiles";
    src = ./getElfFiles.bash;
  };
}
# Only tested on Linux.
// lib.optionalAttrs stdenv.isLinux {
  emptyFile = check {
    name = "emptyFile";
    searchPaths = [ emptyFile ];
    elfFiles = [ ];
  };

  emptyDirectory = check {
    name = "emptyDirectory";
    searchPaths = [ emptyDirectory ];
    elfFiles = [ ];
  };

  hello = check {
    name = "hello";
    searchPaths = [ hello ];
    elfFiles = [ "${hello}/bin/hello" ];
  };

  helloStatic = check {
    name = "helloStatic";
    searchPaths = [ pkgsStatic.hello ];
    elfFiles = [ "${pkgsStatic.hello}/bin/hello" ];
  };

  helloBoth = check {
    name = "helloBoth";
    searchPaths = [
      hello
      pkgsStatic.hello
    ];
    elfFiles = lib.naturalSort [
      "${hello}/bin/hello"
      "${pkgsStatic.hello}/bin/hello"
    ];
  };

  # Ensure data is only appended
  helloWithExistingGoodbye = checkWithExistingGoodbye {
    name = "helloWithExistingGoodbye";
    searchPaths = [ hello ];
    elfFiles = [
      "goodbye"
      "${hello}/bin/hello"
    ];
  };
}
