{
  lib,
  mkLLVMPackages,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  wrapCCWith,
  linkFarm,
}:

let
  inherit (llvmPackages) stdenv;

  # Cling requires its own fork of LLVM.
  llvmPackages_cling =
    (mkLLVMPackages {
      version = "18.1.8+cling-llvm18-20250721-01";
      officialRelease.version = "18.1.8";

      monorepoSrc = fetchFromGitHub {
        owner = "root-project";
        repo = "llvm-project";
        tag = "cling-llvm18-20250721-01";
        hash = "sha256-3nZDFsq6pRPVctTBpX+Ed6Y5LjvNxKFKDX9aOppdFn0=";

        # The fork has a backported patch that we also backport. This
        # hack undoes the patch so that it can apply again cleanly.
        postFetch = ''
          substituteInPlace $out/llvm/include/llvm/ADT/SmallVector.h \
            --replace-fail $'#include <cstdint>\n' ""
        '';
      };
    }).value;

  cling-unwrapped = stdenv.mkDerivation {
    pname = "cling-unwrapped";
    version = "1.2-unstable-2025-09-01";

    src = fetchFromGitHub {
      owner = "root-project";
      repo = "cling";
      rev = "d68b46dc7555da9f2fea067caefd0c1b195785df";
      hash = "sha256-JP7wgctIQbnD2ZcrUm3rRbX8qBQA3QNyXCJz/VK/y1Q=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      python3
    ];

    buildInputs = [
      llvmPackages_cling.llvm
      llvmPackages_cling.libclang
    ];

    strictDeps = true;

    postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mkdir -p $out/share/Jupyter
      cp -r /build/clang/tools/cling/tools/Jupyter/kernel $out/share/Jupyter
    '';

    passthru = {
      isClang = true;
      langC = true;
      langCC = true;
    };

    meta = {
      description = "Interactive C++ Interpreter";
      mainProgram = "cling";
      homepage = "https://root.cern/cling/";
      license = with lib.licenses; [
        lgpl21
        ncsa
      ];
      maintainers = with lib.maintainers; [ thomasjm ];
      platforms = lib.platforms.unix;
    };
  };
in

llvmPackages_cling.clang.override (prev: {
  cc = linkFarm "cling-${cling-unwrapped.version}" {
    "bin/clang++" = "${cling-unwrapped}/bin/cling";
  };

  extraBuildCommands = prev.extraBuildCommands or "" + ''
    mv $out/bin/clang++ $out/bin/cling

    # Drop the symlinks to the bintools.
    find $out/bin -type l -delete
  '';

  nixSupport = prev.nixSupport or { } // {
    # Cling doesn’t support response files.
    cc-wrapper-hook = "NIX_CC_USE_RESPONSE_FILE=0";
  };
})
