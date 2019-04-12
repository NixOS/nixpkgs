{ stdenv, fetchFromGitHub, fetchpatch, cmake, libarcus, stb, protobuf }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "0p4zcckrlrpyp5xdqgvp0phmawyh4cy8vipim9fvgsfcin4vhrv7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
