{ stdenv, fetchFromGitHub, cmake, libarcus, stb }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "083jmhzmb60rmqw0fhbnlxyblzkmpn3k6zc75xq90x5g3h60wib4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus stb ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
