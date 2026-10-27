# Wrapper for clang tools (clang-scan-deps, clang-check, etc.) that sets
# CPATH and CPLUS_INCLUDE_PATH so they can find C/C++ standard library headers.
#
# This is needed because tools like clang-scan-deps are invoked directly by
# build systems (e.g., CMake's C++20 module scanning) without going through
# the cc-wrapper, so they don't get the flags that tell them where headers are.
{
  lib,
  stdenv,
  unwrapped,
  wrapper,
}:
stdenv.mkDerivation {
  pname = "intel-llvm-clang-tools";
  version = unwrapped.version;

  dontUnpack = true;

  # These are used in substituteAll for the wrapper script
  inherit unwrapped;
  clang = wrapper;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    substituteAll ${./clang-tools-wrapper} $out/bin/.clang-tool-wrapper
    chmod +x $out/bin/.clang-tool-wrapper

    for tool in clang-scan-deps clang-check clang-extdef-mapping clang-refactor clang-tidy; do
      if [[ -e $unwrapped/bin/$tool ]]; then
        ln -s $out/bin/.clang-tool-wrapper $out/bin/$tool
      fi
    done

    runHook postInstall
  '';

  meta = unwrapped.meta // {
    description = "Wrapped Intel LLVM clang tools with proper include paths";
  };
}
