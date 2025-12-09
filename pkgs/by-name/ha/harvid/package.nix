{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  unixtools,
  cctools,
  ffmpeg,
  libjpeg,
  libpng,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harvid";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "harvid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p0W+rKHH/iuGOcRjl6b4s6jQYkm7bqWCz849SDI/7fQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    which
    unixtools.xxd
  ];

  buildInputs = [
    ffmpeg
    libjpeg
    libpng
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace libharvid/Makefile \
      --replace-fail /usr/bin/libtool ${cctools}/bin/libtool
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=v${finalAttrs.version}"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decodes still images from movie files and serves them via HTTP";
    longDescription = ''
      harvid's intended use-case is to efficiently provide frame-accurate data
      and act as second level cache for rendering the video-timeline in Ardour,
      but it is not limited to that: it has applications for any task that
      requires a high-performance frame-accurate online image extraction
      processor.
    '';
    homepage = "http://x42.github.io/harvid";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mitchmindtree ];
    mainProgram = "harvid";
  };
})
