{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  SDL,
  SDL_mixer,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powermanga";
  version = "0.93.1";

  src = fetchurl {
    url = "https://linux.tlk.fr/games/Powermanga/download/powermanga-${finalAttrs.version}.tgz";
    sha256 = "sha256-2nU/zoOQWm2z/Y6mXHDFfWYjYshsQp1saVRBcUT5Q+g=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    SDL
    SDL_mixer
    libpng
  ];

  preConfigure = ''
    ./bootstrap
  '';

  installFlags = [
    # Default is $(out)/games
    "gamesdir=$(out)/bin"
    # We set the scoredir to $TMPDIR.
    # Otherwise it will try to write in /var/games at install time
    "scoredir=$(TMPDIR)"
  ];

  meta = with lib; {
    homepage = "https://linux.tlk.fr/games/Powermanga/";
    downloadPage = "https://linux.tlk.fr/games/Powermanga/download/";
    description = "Arcade 2D shoot-em-up game";
    mainProgram = "powermanga";
    longDescription = ''
      Powermanga is an arcade 2D shoot-em-up game with 41 levels and more than
      200 sprites. It runs in 320x200 or 640x400 pixels, with Window mode or
      full screen and support for 8, 15, 16, 24, and 32 bpp. As you go through
      the levels, you will destroy enemy spaceships and bosses, collect gems to
      power up your ship and get special powers, helpers and weapons.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
