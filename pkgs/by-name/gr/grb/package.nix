{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "grb";
  version = "0-unstable-2022-07-02";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "grb";
    rev = "35a5353ab147b930c39e1ccd369791cc4c27f0df";
    sha256 = "sha256-hQ21DXnkBJVCgGXQKDR+DjaDC3RXS2pNmSLDoHvHA4E=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Cli-accessible Greek Bible with the Septuagint, SBL and Apocrypha";
    homepage = "https://github.com/LukeSmithxyz/grb";
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.cafkafk ];
    mainProgram = "grb";
  };
}
