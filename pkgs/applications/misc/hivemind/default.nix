{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "hivemind";
  version = "1.0.6";
  goPackagePath = "github.com/DarthSim/hivemind";

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "hivemind";
    rev = "v${version}";
    sha256 = "0afcnd03wsdphbbpha65rv5pnv0x6ldnnm6rnv1m6xkkywgnzx95";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/DarthSim/;
    description = "Process manager for Procfile-based applications";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.sveitser ];
  };
}
