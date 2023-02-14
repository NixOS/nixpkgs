{
  stdenv,
  cmake,
  fetchFromGitLab,
  sqlite,
  sqlitecpp,
  boost,
  tbb,
  pkgconfig,
  fswatch,
  libargs,
  namedtype,
  gtest,
}: let
  pname = "zetk";
  version = "0.1.2";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitLab {
      owner = "andrejr";
      repo = pname;
      rev = version;
      hash = "sha256-+whU2JGCkwtHmJeinhicNgKLD2cVHBN4SGOfpzCntvw=";
    };

    NamedType_DIR = "${namedtype}/lib/cmake";
    preConfigure = ''
      ln -s ${./FindTBB.cmake} cmake/modules/FindTBB.cmake
    '';

    patches = [./remove-cpm.patch ./set-version.patch];

    cmakeFlags = ["-DPROJECT_VERSION=${version}"];

    nativeBuildInputs = [cmake sqlite.dev sqlitecpp boost tbb fswatch namedtype pkgconfig libargs gtest];
  }
