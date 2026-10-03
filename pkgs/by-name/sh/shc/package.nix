{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "shc";
  version = "4.0.3";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    hash = "sha256-JJmOZ8blcCGJjrR4q4FrA3da9KBpJoRJUFpregkg1i0=";
  };

  meta = {
    homepage = "https://github.com/neurobin/shc";
    description = "Shell Script Compiler";
    mainProgram = "shc";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
  };
}
