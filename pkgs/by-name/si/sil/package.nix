{
  pkgs,
  lib,
  stdenv,
  fetchzip,
  ncurses,
  libX11,
  libXaw,
  libXt,
  libXext,
  libXmu,
  makeWrapper,
  writeScript,
}:

let
  setup = writeScript "setup" ''
    mkdir -p "$ANGBAND_PATH"
    # Copy all the data files into place
    cp -ar $1/* "$ANGBAND_PATH"
    # The copied files are not writable, make them so
    chmod +w -R "$ANGBAND_PATH"
  '';
in
stdenv.mkDerivation rec {
  pname = "Sil";
  version = "1.3.0";

  src = fetchzip {
    url = "https://www.amirrorclear.net/flowers/game/sil/Sil-130-src.zip";
    sha256 = "1amp2mr3fxascra0k76sdsvikjh8g76nqh46kka9379zd35lfq8w";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    ncurses
    libX11
    libXaw
    libXt
    libXext
    libXmu
  ];

  sourceRoot = "${src.name}/Sil/src";

  makefile = "Makefile.std";

  postPatch = ''
    # Allow usage of ANGBAND_PATH
    substituteInPlace config.h --replace "#define FIXED_PATHS" ""
  '';

  preConfigure = ''
    buildFlagsArray+=("LIBS=-lXaw -lXext -lSM -lICE -lXmu -lXt -lX11 -lncurses")
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: main.o:/build/source/Sil/src/externs.h:57: multiple definition of
  #     `mini_screenshot_char'; variable.o:/build/source/Sil/src/externs.h:57: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installPhase = ''
    runHook preInstall

    # the makefile doesn't have a sensible install target, so we have to do it ourselves
    mkdir -p $out/bin
    cp sil $out/bin/sil

    # Wrap the program to set a user-local ANGBAND_PATH, and run the setup script to copy files into place.
    # We could just use the options for a user-local save and scores dir, but it tried to write to the
    # lib directory anyway, so we might as well give everyone a copy
    wrapProgram $out/bin/sil \
      --run "export ANGBAND_PATH=\$HOME/.sil" \
      --run "${setup} ${src}/Sil/lib"

    runHook postInstall
  '';

  passthru.tests = {
    saveDirCreation = pkgs.runCommand "save-dir-creation" { } ''
      HOME=$(pwd) ${lib.getExe pkgs.sil} --help
      test -d .sil && touch $out
    '';
  };

  meta = {
    description = "Rogue-like game set in the First Age of Middle-earth";
    longDescription = ''
      A game of adventure set in the First Age of Middle-earth, when the world still
      rang with Elven song and gleamed with Dwarven mail.

      Walk the dark halls of Angband.  Slay creatures black and fell.  Wrest a shining
      Silmaril from Morgoth’s iron crown.
    '';
    homepage = "http://www.amirrorclear.net/flowers/game/sil/index.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      michaelpj
      kenran
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sil";
  };
}
