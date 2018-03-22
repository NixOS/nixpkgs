{ stdenv, fetchFromGitHub, fetchurl, cgal, boost, gmp, mpfr, flex, bison, dxflib, readline
, qtbase, qmake, libGLU
}:

stdenv.mkDerivation rec {
  version = "0.9.8";
  name = "rapcad-${version}";

  src = fetchFromGitHub {
    owner = "gilesbathgate";
    repo = "rapcad";
    rev = "v${version}";
    sha256 = "0a0sqf6h227zalh0jrz6jpm8iwji7q3i31plqk76i4qm9vsgrhir";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/GilesBathgate/RapCAD/commit/278a8d6c7b8fe08f867002528bbab4a6319a7bb6.patch";
      sha256 = "1vvkyf0wg79zdzs5zlggfrr1lrp1x75dglzl0mspnycwldsdwznj";
      name = "disable-QVector-qHash.patch";
    })
  ];

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase cgal boost gmp mpfr flex bison dxflib readline libGLU ];

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    description = ''Constructive solid geometry package'';
  };
}
