{
  stdenv,
  lib,
  fetchzip,
  installShellFiles,
  libx11,
  ncurses,
  pkg-config,
  enableXwinGraphics ? false,
}:

let
  options = [
    "${if enableXwinGraphics then "XWIN" else "CURSES"}GRAPHX"
    "EXT94"
    "PERMUTATE"
    "RWLIMIT"
  ];
  pkgConfigLibs =
    lib.optionals enableXwinGraphics [ "x11" ] ++ lib.optionals (!enableXwinGraphics) [ "ncurses" ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pmars";
  version = "0.9.5";

  src = fetchzip {
    url = "http://www.koth.org/pmars/pmars-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-p6iZkb0Nrcj7LtAxtS6Ics5CS9taPHbsoIdE5C1QYnI=";
  };

  patches = [
    # ncurses' WINDOW struct was turned opaque for outside code, use functions for accessing values instead
    ./0003-fix-ncurses-opaque-WINDOW.patch
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail 'CC = gcc' "CC = $CC" \
      --replace-fail '@strip' "@$STRIP" \
      --replace-fail 'CFLAGS += -O -DEXT94 -DXWINGRAPHX -DPERMUTATE -DRWLIMIT' "CFLAGS += ${
        lib.concatMapStringsSep " " (opt: "-D${opt}") options
      } ${
        lib.optionalString (
          pkgConfigLibs != [ ]
        ) "$($PKG_CONFIG --cflags ${lib.strings.concatStringsSep " " pkgConfigLibs})"
      }" \
      --replace-fail 'LIB = -L/usr/X11R6/lib -lX11' "LIB = ${
        lib.optionalString (
          pkgConfigLibs != [ ]
        ) "$($PKG_CONFIG --libs ${lib.strings.concatStringsSep " " pkgConfigLibs})"
      }"
  '';

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals (pkgConfigLibs != [ ]) [ pkg-config ];

  buildInputs =
    lib.optionals enableXwinGraphics [ libx11 ] ++ lib.optionals (!enableXwinGraphics) [ ncurses ];

  preConfigure = ''
    cd src
  '';

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 pmars $out/bin/pmars

    mkdir -p $out/share/pmars
    cp -R -t $out/share/pmars/ ../{AUTHORS,COPYING,README,config,warriors}

    installManPage ../doc/pmars.6

    mkdir -p $out/share/doc/pmars
    cp -t $out/share/doc/pmars/ ../doc/{primer.*,redcode.ref}

    runHook postInstall
  '';

  passthru = {
    inherit options;
  };

  meta = {
    description = "Official Core War simulator";
    longDescription = ''
      Portable MARS is the official Core War simulator of the ICWS and the rec.games.corewar newsgroup. pMARS serves as
      a test bed for new Redcode standards and tournament styles. It has also been used in genetic algorithm experiments
      and as an assembly language teaching aid. pMARS is under active development by a group of Core War enthusiasts who
      put a lot of time into this project.
    '';
    homepage = "http://www.koth.org/pmars/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pmars";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
  };
})
