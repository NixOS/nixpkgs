{ stdenv, lib, fetchFromGitHub, libcap, acl, file, readline }:

stdenv.mkDerivation rec {
  pname = "clifm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "leo-arch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mf9lrq0l532vyf4ycsikrw8imn4gkavyn3cr42nhjsr1drygrp8";
  };

  buildInputs = [ libcap acl file readline ];

  makeFlags = [
    "INSTALLPREFIX=${placeholder "out"}/bin"
    "DESKTOPPREFIX=${placeholder "out"}/share"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/share
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/leo-arch/clifm";
    description = "CliFM is a CLI-based, shell-like, and non-curses terminal file manager written in C: simple, fast, extensible, and lightweight as hell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.unix;
  };
}
