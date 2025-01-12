{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "grb";
  version = "unstable-2022-07-02";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = pname;
    rev = "35a5353ab147b930c39e1ccd369791cc4c27f0df";
    sha256 = "sha256-hQ21DXnkBJVCgGXQKDR+DjaDC3RXS2pNmSLDoHvHA4E=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Cli-accessible Greek Bible with the Septuagint, SBL and Apocrypha";
    homepage = "https://github.com/LukeSmithxyz/grb";
    license = licenses.publicDomain;
    maintainers = [ maintainers.cafkafk ];
    mainProgram = "grb";
  };
}
