{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  libccd,
  octomap,
}:

stdenv.mkDerivation rec {
  pname = "fcl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "flexible-collision-library";
    repo = pname;
    rev = version;
    sha256 = "0f5lhg6f9np7w16s6wz4mb349bycil1irk8z8ylfjwllxi4n6x7a";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    eigen
    libccd
    octomap
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Flexible Collision Library";
    longDescription = ''
      FCL is a library for performing three types of proximity queries on a
      pair of geometric models composed of triangles.
    '';
    homepage = "https://github.com/flexible-collision-library/fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}
