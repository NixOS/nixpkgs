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
  pname = "flintc";
  version = "0.3.5-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "flintc";
    # tag = "v${finalAttrs.version}-core";
    rev = "c020a74efe31d40a1cdaf1b8373e3d878432080f";
    sha256 = "sha256-xL4OcN+V648OxRb2ic0WPSEk/AJLa9ybSVib+VJ4DyU=";
  };

  llvm-src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    tag = "llvmorg-21.1.8";
    hash = "sha256-pgd8g9Yfvp7abjCCKSmIn1smAROjqtfZaJkaUkBSKW0=";
  };

  fip-src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "fip";
    rev = "aa697b3e0c513e3e8c7cdbfa957789a3927c7222";
    hash = "sha256-+IANlA04XE3P+HoybsDPfPT46DK3iBNzg0dtL7E/IB0=";
  };

  json-mini-src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "json-mini";
    rev = "a32d6e8319d90f5fa75f1651f30798c71464e4c6";
    hash = "sha256-c4eaCc5ymTE+1JqaKZwSJ3gQUlmcCQvo4N63gUmqKG0=";
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
    "-Dfip-dir=${finalAttrs."fip-src"}"
    "-Djson-mini-dir=${finalAttrs."json-mini-src"}"
    "-Dgit-hash=${finalAttrs.src.rev}"
  ];

  meta = with lib; {
    description = "Flint programming language compiler and language server";
    homepage = "https://github.com/flint-lang/flintc";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "flintc";
  };
})
