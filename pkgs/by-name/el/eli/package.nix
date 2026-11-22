{
  lib,
  stdenv,
  fetchurl,
  symlinkJoin,
  makeWrapper,
  tcl,
  fontconfig,
  tk,
  ncurses,
  libxt,
  libxext,
  libxaw,
  libx11,
  file,
}:

let
  # eli derives the location of the include folder from the location of the lib folder
  tk_combined = symlinkJoin {
    name = "tk_combined";
    paths = [
      tk
      tk.dev
    ];
  };
  curses_combined = symlinkJoin {
    name = "curses_combined";
    paths = [
      ncurses
      ncurses.dev
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "eli";
  version = "4.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/eli-project/Eli/Eli%20${finalAttrs.version}/eli-${finalAttrs.version}.tar.bz2";
    sha256 = "1vran8583hbwrr5dciji4zkhz3f88w4mn8n9sdpr6zw0plpf1whj";
  };

  patches = [
    # Newer GCC will reject function parameters with an implicit type of `int` and undefined
    # references to undeclared functions.
    ./function-declarations.patch
  ];

  buildInputs = [
    ncurses
    fontconfig
    libx11.dev
    libxt.dev
    libxaw.dev
    libxext.dev
  ];

  nativeBuildInputs = [
    file
    makeWrapper
  ];

  # skip interactive browser check
  buildFlags = [ "nobrowsers" ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: cexp.o:(.bss+0x40): multiple definition of `obstck'; cccp.o:(.bss+0x0): first defined here
  # Workaround build failure on "function definitions with identifier lists":
  #   C23 throws errors on "function definitions with identifier lists". As it is pervasively used
  #   in the upstream codebase, it's impossible to fix that legacy syntax without a full treewide
  #   refactor. So the currently fix is to pin the standard to C17.
  env.NIX_CFLAGS_COMPILE = "-fcommon --std=gnu17";

  preConfigure = ''
    configureFlagsArray=(
      --with-tcltk="${tcl} ${tk_combined}"
      --with-curses="${curses_combined}"
    )
    export ODIN_LOCALIPC=1
  '';

  postInstall = ''
    wrapProgram "$out/bin/eli" \
      --set ODIN_LOCALIPC 1
  '';

  # Test if eli starts
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMP/home"
    mkdir -p "$HOME"
    $out/bin/eli "!ls"
  '';

  meta = {
    description = "Translator Construction Made Easy";
    longDescription = ''
      Eli is a programming environment that supports all phases of translator
      construction with extensive libraries implementing common tasks, yet handling
      arbitrary special cases. Output is the C subset of C++.
    '';
    homepage = "https://eli-project.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ timokau ];
    platforms = lib.platforms.linux;
  };
})
