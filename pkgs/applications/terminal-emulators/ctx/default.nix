{ lib
, stdenv
, fetchgit
<<<<<<< HEAD
, pkg-config
, xxd
, SDL2
, alsa-lib
, babl
, bash
, cairo
, curl
, libdrm # Not documented
=======
, SDL2
, alsa-lib
, babl
, curl
, libdrm # Not documented
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, enableFb ? false
, nixosTests
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "ctx";
  version = "unstable-2023-06-05";
=======
stdenv.mkDerivation rec {
  pname = "ctx";
  version = "0.pre+date=2021-10-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    name = "ctx-source"; # because of a dash starting the directory
    url = "https://ctx.graphics/.git/";
<<<<<<< HEAD
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
=======
    rev = "d11d0d1a719a3c77712528e2feed8c0878e0ea64";
    sha256 = "sha256-Az3POgdvDOVaaRtzLlISDODhAKbefpGx5KgwO3dttqs=";
  };

  nativeBuildInputs = [
    pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    SDL2
    alsa-lib
    babl
<<<<<<< HEAD
    bash # for ctx-audioplayer
    cairo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    curl
    libdrm
  ];

  configureScript = "./configure.sh";
  configureFlags = lib.optional enableFb "--enable-fb";
<<<<<<< HEAD
  configurePlatforms = [];
  dontAddPrefix = true;
  dontDisableStatic = true;
=======
  dontAddPrefix = true;

  hardeningDisable = [ "format" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
