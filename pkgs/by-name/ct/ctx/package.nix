{
  lib,
  stdenv,
  fetchgit,
  SDL2,
  alsa-lib,
  babl,
  bash,
  curl,
  libdrm, # Not documented
  pkg-config,
  xxd,
  enableFb ? false,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctx";
  version = "unstable-2023-09-03";

  src = fetchgit {
    name = "ctx-source"; # because of a dash starting the directory
    url = "https://ctx.graphics/.git/";
    rev = "1bac18c152eace3ca995b3c2b829a452085d46fb";
    hash = "sha256-fOcQJ2XCeomdtAUmy0A+vU7Vt325OSwrb1+ccW+gZ38=";
  };

  patches = [
    # Many problematic things fixed - it should be upstreamed somehow:
    # - babl changed its name in pkg-config files
    # - arch detection made optional
    # - LD changed to CCC
    # - remove inexistent reference to static/*/*
    ./0001-fix-detections.diff
  ];

  postPatch = ''
    patchShebangs ./tools/gen_fs.sh
  '';

  nativeBuildInputs = [
    pkg-config
    xxd
  ];

  buildInputs = [
    SDL2
    alsa-lib
    babl
    bash # for ctx-audioplayer
    curl
    libdrm
  ];

  strictDeps = true;

  env.ARCH = stdenv.hostPlatform.parsed.cpu.arch;

  configureScript = "./configure.sh";
  configureFlags = lib.optional enableFb "--enable-fb";
  configurePlatforms = [ ];
  dontAddPrefix = true;
  dontDisableStatic = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.tests.test = nixosTests.terminal-emulators.ctx;

  meta = {
    homepage = "https://ctx.graphics/";
    description = "Vector graphics terminal";
    longDescription = ''
      ctx is an interactive 2D vector graphics, audio, text- canvas and
      terminal, with escape sequences that enable a 2D vector drawing API using
      a vector graphics protocol.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
