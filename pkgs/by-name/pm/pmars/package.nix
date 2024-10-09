{
  stdenv,
  lib,
  fetchzip,
  installShellFiles,
  libX11,
  ncurses,
  pkg-config,
  graphxMode ? "${if stdenv.hostPlatform.isLinux then "XWIN" else "CURSES"}GRAPHX",
}:

let
  options = [
    graphxMode
    "EXT94"
    "PERMUTATE"
    "RWLIMIT"
  ];
  pkgConfigLibs =
    lib.optionals (graphxMode == "XWINGRAPHX") [ "x11" ]
    ++ lib.optionals (
      graphxMode == "CURSESGRAPHX" || (!stdenv.hostPlatform.isLinux && graphxMode == "GRAPHX")
    ) [ "ncurses" ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pmars";
  version = "0.9.4";

  src = fetchzip {
    url = "http://www.koth.org/pmars/pmars-${finalAttrs.version}.zip";
    hash = "sha256-68zsH9HWWp13pozjMajayS/VhY8iTosUp1CvcAmj/dE=";
  };

  patches = [
    # redefinition of 'round' as different kind of symbol
    ./0001-fix-round-redefinition.patch

    # call to undeclared function 'sighandler'
    ./0002-fix-sighandler-declaration.patch
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail 'CC = gcc' "CC = $CC" \
      --replace-fail '@strip' "@$STRIP" \
      --replace-fail 'CFLAGS = -O -DEXT94 -DXWINGRAPHX -DPERMUTATE -DRWLIMIT' "CFLAGS = ${
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
    lib.optionals (graphxMode == "XWINGRAPHX") [ libX11 ]
    ++ lib.optionals (
      graphxMode == "CURSESGRAPHX" || (!stdenv.hostPlatform.isLinux && graphxMode == "GRAPHX")
    ) [ ncurses ];

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
