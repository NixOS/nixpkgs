{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hivemind-${version}";
  version = "1.0.4";
  goPackagePath = "github.com/DarthSim/hivemind";

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "hivemind";
    rev = "v${version}";
    sha256 = "1z2izvyf0j3gi0cas5v22kkmkls03sg67182k8v3p6kwhzn0jw67";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/DarthSim/;
    description = "Process manager for Procfile-based applications";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.sveitser ];
  };
}
