# NOTE: Tests related to getRunpathEntries go here.
{
  emptyFile,
  getRunpathEntries,
  hello,
  lib,
  pkgsStatic,
  stdenv,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers)
    shellcheck
    shfmt
    testBuildFailure'
    testEqualArrayOrMap
    ;

  check =
    {
      name,
      elfFile,
      runpathEntries,
    }:
    (testEqualArrayOrMap {
      inherit name;
      expectedArray = runpathEntries;
      script = ''
        set -eu
        nixLog "running getRunpathEntries with ''${elfFile@Q} to populate actualArray"
        getRunpathEntries "$elfFile" actualArray || {
          nixErrorLog "getRunpathEntries failed"
          exit 1
        }
      '';
    }).overrideAttrs
      (prevAttrs: {
        inherit elfFile;
        nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ getRunpathEntries ];
        meta = prevAttrs.meta or { } // {
          platforms = lib.platforms.linux;
        };
      });
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "getRunpathEntries";
    src = ./getRunpathEntries.bash;
  };

  shfmt = shfmt {
    name = "getRunpathEntries";
    src = ./getRunpathEntries.bash;
  };
}
# Only tested on Linux.
// lib.optionalAttrs stdenv.hostPlatform.isLinux {
  # Not an ELF file
  notElfFileFails = testBuildFailure' {
    name = "notElfFileFails";
    drv = check {
      name = "notElfFile";
      elfFile = emptyFile;
      runpathEntries = [ ];
    };
    expectedBuilderLogEntries = [
      "getRunpathEntries failed"
    ];
  };

  # Not a dynamic ELF file
  staticElfFileFails = testBuildFailure' {
    name = "staticElfFileFails";
    drv = check {
      name = "staticElfFile";
      elfFile = lib.getExe pkgsStatic.hello;
      runpathEntries = [ ];
    };
    expectedBuilderLogEntries = [
      "getRunpathEntries failed"
    ];
  };

  hello = check {
    name = "hello";
    elfFile = lib.getExe hello;
    runpathEntries = [
      "${lib.getLib stdenv.cc.libc}/lib"
    ];
  };

  libstdcplusplus = check {
    name = "libstdcplusplus";
    elfFile = "${lib.getLib stdenv.cc.cc}/lib/libstdc++.so";
    runpathEntries = [
      "${lib.getLib stdenv.cc.cc}/lib"
      "${lib.getLib stdenv.cc.libc}/lib"
    ];
  };
}
