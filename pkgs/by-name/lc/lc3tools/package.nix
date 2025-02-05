{
  lib,
  stdenv,
  fetchurl,
  unzip,
  flex,
  tk,
  ncurses,
  readline,
}:

stdenv.mkDerivation {
  pname = "lc3tools";
  version = "0.12";

  src = fetchurl {
    url = "https://highered.mheducation.com/sites/dl/free/0072467509/104652/lc3tools_v12.zip";
    hash = "sha256-PTM0ole8pHiJmUaahjPwcBQY8/hVVgQhADZ4bSABt3I=";
  };

  patches = [
    # the original configure looks for things in the FHS path
    # I have modified it to take environment vars
    ./0001-mangle-configure.patch

    # lc3sim looks for the LC3 OS in $out/share/lc3tools instead of $out
    ./0002-lc3os-path.patch

    # lc3sim-tk looks for lc3sim in $out/bin instead of $out
    ./0003-lc3sim-tk-path.patch

    # use `cc` instead of `gcc`; on macOS the latter is not present
    ./0004-configure-use-cc.patch
  ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    flex
    tk
    ncurses
    readline
  ];

  # lumetta published this a while ago but handrolled his configure
  # jank in the original packaging makes this necessary:
  LIBS = "${flex}/lib:${ncurses}/lib:${readline}/lib";
  INCLUDES = "${flex}/include:${ncurses}/include:${readline}/include";

  # it doesn't take `--prefix`
  prefixKey = "--installdir ";

  postInstall = ''
    mkdir -p $out/{bin,share/lc3tools}

    mv -t $out/share/lc3tools $out/{COPYING,NO_WARRANTY,README} $out/lc3os*
    mv -t $out/bin $out/lc3*
  '';

  meta = with lib; {
    longDescription = ''
      The LC-3 tools package contains the lc3as assembler, the lc3sim simulator,
      and lc3sim-tk, a Tcl/Tk-based GUI frontend to the simulator.
    '';
    description = "Toolchain and emulator for the LC-3 architecture";
    homepage = "https://highered.mheducation.com/sites/0072467509/student_view0/lc-3_simulator.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ anna328p ];
    mainProgram = "lc3sim-tk";
    platforms = with lib.platforms; unix ++ windows;
  };
}
