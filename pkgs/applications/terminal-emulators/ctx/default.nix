{ lib
, stdenv
, fetchgit
, pkg-config
, xxd
, SDL2
, alsa-lib
, babl
, bash
, cairo
, curl
, libdrm # Not documented
, enableFb ? false
, nixosTests
}:

stdenv.mkDerivation {
  pname = "ctx";
  version = "unstable-2023-06-05";

  src = fetchgit {
    name = "ctx-source"; # because of a dash starting the directory
    url = "https://ctx.graphics/.git/";
    rev = "2eb3886919d0a0b8c305e4f9e18428dad5e73ca0";
    sha256 = "sha256-PLUyGArxLU742IKIgpzxdBdc94mWWSkHNFoXGW8L/Zo=";
  };

  patches = [
    ./0001-Make-arch-detection-optional-and-fix-targets.patch
  ];

  postPatch = ''
    patchShebangs ./tools/gen_fs.sh
  '';

  strictDeps = true;

  env.ARCH = stdenv.hostPlatform.parsed.cpu.arch;

  nativeBuildInputs = [
    pkg-config
    xxd
  ];

  buildInputs = [
    SDL2
    alsa-lib
    babl
    bash # for ctx-audioplayer
    cairo
    curl
    libdrm
  ];

  configureScript = "./configure.sh";
  configureFlags = lib.optional enableFb "--enable-fb";
  configurePlatforms = [];
  dontAddPrefix = true;
  dontDisableStatic = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.tests.test = nixosTests.terminal-emulators.ctx;

  meta = with lib; {
    homepage = "https://ctx.graphics/";
    description = "Vector graphics terminal";
    longDescription= ''
      ctx is an interactive 2D vector graphics, audio, text- canvas and
      terminal, with escape sequences that enable a 2D vector drawing API using
      a vector graphics protocol.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres];
    platforms = platforms.unix;
  };
}
