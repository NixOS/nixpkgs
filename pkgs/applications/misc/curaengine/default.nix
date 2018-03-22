{ stdenv, fetchFromGitHub, cmake, libarcus }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "1yqpp6qhixzni3ik11vbk5kcdrhlz2j4ylzmh8f6c86r4d73a0cp";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
