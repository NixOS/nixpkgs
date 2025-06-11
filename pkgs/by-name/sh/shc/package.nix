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
    sha256 = "0bfn404plsssa14q89k9l3s5lxq3df0sny5lis4j2w75qrkqx694";
  };

  meta = with lib; {
    homepage = "https://neurobin.org/projects/softwares/unix/shc/";
    description = "Shell Script Compiler";
    mainProgram = "shc";
    platforms = lib.platforms.all;
    license = licenses.gpl3;
  };
}
