{lib, stdenv, fetchFromGitHub, flex, bison, cmake, zlib}:

stdenv.mkDerivation {
  version = "2018-08-15";
  pname = "pbrt-v3";

  src = fetchFromGitHub {
    rev = "86b5821308088deea70b207bc8c22219d0103d65";
    owner  = "mmp";
    repo   = "pbrt-v3";
    sha256 = "0f7ivsczba6zfk5f0bba1js6dcwf6w6jrkiby147qp1sx5k35cv8";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/mmp/pbrt-v3/issues/196
    ./openexr-cmake-3.12.patch
  ];

  nativeBuildInputs = [ flex bison cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    homepage = "https://pbrt.org/";
    description = "Renderer described in the third edition of the book 'Physically Based Rendering: From Theory To Implementation'";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.juliendehos ];
    priority = 10;
  };
}
