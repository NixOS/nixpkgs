{ lib
, stdenv
, fetchgit
, SDL2
, alsa-lib
, babl
, curl
, libdrm # Not documented
, pkg-config
, enableFb ? false
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "ctx";
  version = "0.pre+date=2021-10-09";

  src = fetchgit {
    name = "ctx-source"; # because of a dash starting the directory
    url = "https://ctx.graphics/.git/";
    rev = "d11d0d1a719a3c77712528e2feed8c0878e0ea64";
    sha256 = "sha256-Az3POgdvDOVaaRtzLlISDODhAKbefpGx5KgwO3dttqs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
    alsa-lib
    babl
    curl
    libdrm
  ];

  configureScript = "./configure.sh";
  configureFlags = lib.optional enableFb "--enable-fb";
  dontAddPrefix = true;

  hardeningDisable = [ "format" ];

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
