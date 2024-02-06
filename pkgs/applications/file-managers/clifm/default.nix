{ stdenv, lib, fetchFromGitHub, libcap, acl, file, readline, python3 }:

stdenv.mkDerivation rec {
  pname = "clifm";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "leo-arch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tjxsJv5w0Rvk2XYisncytcRdZLRnOSDJmNJN4kkzr7U=";
  };

  buildInputs = [ libcap acl file readline python3];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "DATADIR=/share"
    "PREFIX=/"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/leo-arch/clifm";
    description = "CliFM is a CLI-based, shell-like, and non-curses terminal file manager written in C: simple, fast, extensible, and lightweight as hell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nadir-ishiguro ];
    platforms = platforms.unix;
  };
}
