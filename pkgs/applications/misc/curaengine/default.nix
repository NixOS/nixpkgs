{ stdenv, fetchFromGitHub, fetchpatch, cmake, libarcus, stb }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "1iwmblvs3qw57698i8bbazyxha18bj9irnkcscdb0596g8q93fcm";
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
