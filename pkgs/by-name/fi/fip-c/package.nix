{
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  lib,
  lld,
  zig,
  cmake,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fip-c";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "fip";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-UeuJOB3jUpmfHqH+MCq6/4RU/oEAb/ic2IeUls6tWTQ=";
  };

  llvm-src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    tag = "llvmorg-21.1.8";
    hash = "sha256-pgd8g9Yfvp7abjCCKSmIn1smAROjqtfZaJkaUkBSKW0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    lld
    zig
    cmake
    ninja
    python3
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "--release=small"
    "-Dllvm-dir=${finalAttrs."llvm-src"}"
  ];

  meta = with lib; {
    description = "C Interop Module utilizing the Flint Interop Protocol";
    homepage = "https://github.com/flint-lang/fip";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "fip-c";
  };
})
