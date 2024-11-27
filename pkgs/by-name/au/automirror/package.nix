{lib, stdenv, fetchFromGitHub, git, ronn}:

stdenv.mkDerivation rec {
  pname = "automirror";
  version = "49";

  src = fetchFromGitHub {
    owner = "schlomo";
    repo = "automirror";
    rev = "v${version}";
    sha256 = "1syyf7dcm8fbyw31cpgmacg80h7pg036dayaaf0svvdsk0hqlsch";
  };

  patchPhase = "sed -i s#/usr##g Makefile";

  buildInputs = [ git ronn ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/schlomo/automirror";
    description = "Automatic Display Mirror";
    license = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = "automirror";
  };
}
