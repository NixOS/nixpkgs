{ gcc8Stdenv, callPackage, fetchgit, fetchpatch, cmake, libarcusLulzbot, stb, protobuf }:

gcc8Stdenv.mkDerivation rec {
  pname = "curaengine-lulzBot";
  version = "3.6.21";

  src = fetchgit {
    url = https://code.alephobjects.com/source/curaengine-lulzbot.git;
    rev = "ec6a1a0f0aa387ef97e5c106633cf8d7fb9cd00d";
    sha256 = "0wdkvg1hmqp1gaym804lw09x4ngf5ffasd861jhflpy7djbmkfn8";
  };

  patches = [ ./curaengine-openmp-compat.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcusLulzbot stb protobuf ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with gcc8Stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = https://code.alephobjects.com/source/curaengine-lulzbot/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
