{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "openddl-parser";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kimkulling";
    repo = "openddl-parser";
    rev = "v${version}";
    hash = "sha256-0tiguBuOJe4NSM9jf4+u+W+nfq55ZCjrGvQ4SGNJLpE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = true;

  meta = {
    description = "Cimple and fast OpenDDL Parser";
    homepage = "https://github.com/kimkulling/openddl-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
