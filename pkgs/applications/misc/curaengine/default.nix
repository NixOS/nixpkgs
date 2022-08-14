{ lib, stdenv, fetchFromGitHub, cmake, libarcus, stb, protobuf }:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "sha256-DCYJDcFwfMegiro/H925MZLFyWXzvXWyEQFHCQukQQI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
