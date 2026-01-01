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
    repo = "fcl";
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Flexible Collision Library";
    longDescription = ''
      FCL is a library for performing three types of proximity queries on a
      pair of geometric models composed of triangles.
    '';
    homepage = "https://github.com/flexible-collision-library/fcl";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.unix;
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
