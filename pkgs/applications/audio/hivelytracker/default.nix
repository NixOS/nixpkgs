{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, SDL
, SDL_image
, SDL_ttf
, gtk2
, glib
}:

stdenv.mkDerivation rec {
  pname = "hivelytracker";
  version = "unstable-2020-08-19";

  src = fetchFromGitHub {
    owner = "pete-gordon";
    repo = "hivelytracker";
    rev = "c8e3c7a5ee9f4a07cb4a941caecf7e4c4f4d40e0";
    sha256 = "1nqianlf1msir6wqwapi7ys1vbmf6aik58wa54b6cn5v6kwxh75a";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    gtk2
    glib
  ];

  makeFlags = [
    "-C sdl"
    "-f Makefile.linux"
    "PREFIX=$(out)"
  ];

  # TODO: try to exclude gtk and glib from darwin builds
  NIX_CFLAGS_COMPILE = [
    "-I${SDL}/include/SDL"
    "-I${SDL_image}/include/SDL"
    "-I${SDL_ttf}/include/SDL"
    "-I${gtk2.dev}/include/gtk-2.0"
    "-I${glib.dev}/include/glib-2.0"
  ];

  # Also build the hvl2wav tool
  postBuild = ''
    make -C hvl2wav
  '';

  postInstall = ''
    # https://github.com/pete-gordon/hivelytracker/issues/43
    # Ideally we should patch the sources, but the program can't open
    # files passed as arguments anyway, so this works well enough until the
    # issue is fixed.
    wrapProgram $out/bin/hivelytracker \
      --chdir "$out/share/hivelytracker"

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
    maintainers = with maintainers; [ fgaz ];
    broken = stdenv.isDarwin; # TODO: try to use xcbuild
  };
}

