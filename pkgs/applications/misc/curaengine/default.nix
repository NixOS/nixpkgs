{ stdenv, fetchFromGitHub, cmake, libarcus }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "1vixxxpwrprcrma0v5ckjvcy45pj32rkf5pk4w7rans9k2ig66ic";
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
