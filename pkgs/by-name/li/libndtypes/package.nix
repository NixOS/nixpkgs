{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "libndtypes";
  version = "0.2.0dev3-unstable-2019-07-30";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "xnd-project";
    repo = "libndtypes";
    rev = "3ce6607c96d8fe67b72cc0c97bf595620cdd274e";
    hash = "sha256-AXQ4F7hFdbRocuIc/tgvhazP6CXp5klipSErJwEeYKA=";
  };

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  doCheck = true;

  meta = {
    description = "Dynamic types for data description and in-memory computations";
    homepage = "https://xnd.io/";
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.costrouc ];
  };
}
