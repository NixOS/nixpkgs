{ stdenv, fetchFromGitHub, cgal, boost, gmp, mpfr, flex, bison, dxflib, readline
, qtbase, qmakeHook, mesa_glu
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

  nativeBuildInputs = [ qmakeHook ];
  buildInputs = [ qtbase cgal boost gmp mpfr flex bison dxflib readline mesa_glu ];

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    description = ''Constructive solid geometry package'';
    broken = true; # redefines template instance added in Qt 5.6
  };
}
