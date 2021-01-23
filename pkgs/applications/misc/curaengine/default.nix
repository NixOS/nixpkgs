{ lib, stdenv, fetchFromGitHub, cmake, libarcus, stb, protobuf }:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "083l327ry6hv3yaa1p8dx1hx7fm12b0lh5nlbshxjyym0vi15rw2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
