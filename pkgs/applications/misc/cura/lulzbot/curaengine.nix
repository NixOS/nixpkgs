{ lib, gcc8Stdenv, callPackage, fetchFromGitLab, fetchpatch, cmake, libarcusLulzbot, stb, protobuf }:

gcc8Stdenv.mkDerivation rec {
  pname = "curaengine-lulzBot";
  version = "3.6.21";

  src = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "cura-engine-le";
    rev = "v${version}";
    sha256 = "0wdkvg1hmqp1gaym804lw09x4ngf5ffasd861jhflpy7djbmkfn8";
  };

  patches = [ ./curaengine-openmp-compat.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcusLulzbot stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://gitlab.com/lulzbot3d/cura-le/cura-engine-le";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
