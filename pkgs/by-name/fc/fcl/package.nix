{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  libccd,
  octomap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "flexible-collision-library";
    repo = "fcl";
    rev = finalAttrs.version;
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

  meta = {
    description = "Flexible Collision Library";
    longDescription = ''
      FCL is a library for performing three types of proximity queries on a
      pair of geometric models composed of triangles.
    '';
    homepage = "https://github.com/flexible-collision-library/fcl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.unix;
  };
})
