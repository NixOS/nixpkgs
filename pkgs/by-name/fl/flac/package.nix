{
  cmake,
  doxygen,
  fetchurl,
  graphviz,
  lib,
  libogg,
  nix-update-script,
  buildPackages,
  pkg-config,
  stdenv,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flac";
  version = "1.5.0";

  # Building from tarball instead of GitHub to include pre-built manpages.
  # This prevents huge numbers of rebuilds for pandoc / haskell-updates.
  # It also enables manpages for platforms where pandoc is not available.
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/flac-${finalAttrs.version}.tar.xz";
    hash = "sha256-8sHHZZKoL//4QTujxKEpm2x6sGxzTe4D/YhjBIXCuSA=";
  };

  hardeningDisable = [ "trivialautovarinit" ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [ libogg ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isStatic) [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  CFLAGS = [
    "-O3"
    "-funroll-loops"
  ];
  CXXFLAGS = [ "-O3" ];

  patches = [ ./package.patch ];
  doCheck = true;

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
    "man"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    changelog = "https://github.com/xiph/flac/releases/tag/${finalAttrs.version}";
    mainProgram = "flac";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      bsd3
      fdl13Plus
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ ruuda ];
  };
})
