{ stdenv, fetchFromGitHub, cmake, libarcus }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "0x1ss3hppw6062rmmxh0dpnm5cg6r2mp01k0nxyw5riiljj59ydy";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libarcus ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
