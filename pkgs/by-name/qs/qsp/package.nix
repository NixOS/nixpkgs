{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  oniguruma,
}:
stdenv.mkDerivation {
  name = "qsp";
  version = "0-unstable-2024-11-27";
  src = fetchFromGitHub {
    owner = "QSPFoundation";
    repo = "qsp";
    rev = "f6ede7f8756e49604de056fcbdfe99fa4abd4812";
    hash = "sha256-MoNam2IFnLpk02tKp+lkl4l+mBiaWNPhFc3/n4zUHcw=";
  };
  buildInputs = [ oniguruma ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  cmakeFlags = [ (lib.cmakeBool "USE_INSTALLED_ONIGURUMA" true) ];
  meta = {
    description = "QuestSoft game engine";
    homepage = "https://qsp.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.JohnMolotov ];
  };
}
