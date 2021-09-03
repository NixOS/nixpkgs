{ lib, stdenv, fetchFromGitHub, cmake, libarcus, stb, protobuf }:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "sha256-t5i6s0KKcaoMqzDxZ6JL1NyKP33uxWdmyziK3xh8q88=";
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
