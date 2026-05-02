{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  zlib,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iqtree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "iqtree";
    repo = "iqtree3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ussHrw/lR7XjN8USHbV+Es88hF0HQOeSYZ7lMIoxJhk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    eigen
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_CMAPLE" false) # tries to download googletest
  ];

  meta = {
    homepage = "https://iqtree.github.io/";
    description = "Efficient and versatile phylogenomic software by maximum likelihood";
    mainProgram = "iqtree3";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.linux;
  };
})
