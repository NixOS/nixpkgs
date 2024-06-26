{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL
, SDL_image
, SDL_ttf
, gtk3
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hivelytracker";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "pete-gordon";
    repo = "hivelytracker";
    rev = "V${lib.replaceStrings ["."] ["_"] finalAttrs.version}";
    sha256 = "148p320sd8phcpmj4m85ns5zly2dawbp8kgx9ryjfdk24pa88xg6";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    gtk3
  ];

  makeFlags = [
    "-C sdl"
    "-f Makefile.linux"
    "PREFIX=$(out)"
  ];

  # Also build the hvl2wav tool
  postBuild = ''
    make -C hvl2wav
  '';

  postInstall = ''
    # Also install the hvl2wav tool
    install -Dm755 hvl2wav/hvl2wav $out/bin/hvl2wav
  '';

  meta = with lib; {
    homepage = "http://www.hivelytracker.co.uk/";
    downloadPage = "http://www.hivelytracker.co.uk/downl.php";
    description = "Chip music tracker based upon the AHX format";
    longDescription = ''
      Hively Tracker is a tracker program based upon the AHX format created in
      the mid '90s by Dexter and Pink of Abyss. The format was relatively
      popular, and many songs were created and used in scene productions and
      games. AHX was designed to create a very SID-like sound on the Amiga.

      HivelyTracker can import and export modules and instruments in the AHX
      format, but it also improves on AHX in several ways and therefore has
      its own instrument and module formats.
    '';
    license = licenses.bsd3;
    platforms = platforms.all;
    mainProgram = "hivelytracker";
    maintainers = with maintainers; [ fgaz ];
    broken = stdenv.isDarwin; # TODO: try to use xcbuild
  };
})
