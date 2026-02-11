{
  stdenv,
  lib,
  fetchFromGitHub,
  bison,
  flex,
  pkg-config,
  darwin,
  xcbuild,
  libsndfile,
  alsa-lib,
  libjack2,
  libpulseaudio,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.5.6";
  pname = "chuck";

  src = fetchFromGitHub {
    owner = "ccrma";
    repo = "chuck";
    tag = "chuck-${finalAttrs.version}";
    hash = "sha256-KBmMpycNCjRZJPdRR3HG5nqHQhhVOENciRpiQ7buyok=";
  };

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
    xcbuild
  ];

  buildInputs = [
    libsndfile
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    alsa-lib
    libpulseaudio
    libjack2
  ];

  makeFlags = [
    "-C src"
    "DESTDIR=$(out)/bin"
    # fix hardcoded gcc
    "CC=cc"
    "CXX=c++"
  ];
  buildFlags = [ (if stdenv.hostPlatform.isDarwin then "mac" else "linux-all") ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=chuck-(.*)" ]; };

  meta = {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = with lib.licenses; [
      gpl2Plus
      # or
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "chuck";
  };
})
