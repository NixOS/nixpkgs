{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "devmem2";
  version = "unstable-2004-08-05";

  src = fetchurl {
    urls = [
      "http://lartmaker.nl/lartware/port/devmem2.c"
      "https://raw.githubusercontent.com/hackndev/tools/7ed212230f8fbb1da3424a15ee88de3279bf96ec/devmem2.c"
    ];
    sha256 = "14f1k7v6i1yaxg4xcaaf5i4aqn0yabba857zjnbg9wiymy82qf7c";
  };

  hardeningDisable = [ "format" ];  # fix compile error

  buildCommand = ''
    $CC "$src" -o devmem2
    install -D devmem2 "$out/bin/devmem2"
  '';

  meta = with lib; {
    description = "Simple program to read/write from/to any location in memory";
    mainProgram = "devmem2";
    homepage = "http://lartmaker.nl/lartware/port/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
