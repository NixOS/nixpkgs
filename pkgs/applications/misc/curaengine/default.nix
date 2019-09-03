{ stdenv, fetchFromGitHub, cmake, libarcus, stb, protobuf }:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "13hbzsx4fwrbwviyhh8z04gs9b0m8fjl8a31ci7gr2dfdmgjs6pd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
