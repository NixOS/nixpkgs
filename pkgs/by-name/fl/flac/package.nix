{
  cmake,
  doxygen,
  fetchFromGitHub,
  graphviz,
  lib,
  libogg,
  nix-update-script,
  buildPackages,
  pkg-config,
  stdenv,
  versionCheckHook,
  enableManpages ? buildPackages.pandoc.compiler.bootstrapAvailable,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flac";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "flac";
    tag = finalAttrs.version;
    hash = "sha256-B6XRai5UOAtY/7JXNbI3YuBgazi1Xd2ZOs6vvLq9LIs=";
  };

  hardeningDisable = [ "trivialautovarinit" ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ]
  ++ lib.optional enableManpages buildPackages.pandoc;

  buildInputs = [ libogg ];

  cmakeFlags =
    lib.optionals (!stdenv.hostPlatform.isStatic) [
      "-DBUILD_SHARED_LIBS=ON"
    ]
    ++ lib.optionals (!enableManpages) [
      "-DINSTALL_MANPAGES=OFF"
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
  ]
  ++ lib.optionals enableManpages [
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
