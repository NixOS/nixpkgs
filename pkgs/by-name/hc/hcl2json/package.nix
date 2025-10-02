{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "hcl2json";
    rev = "v${version}";
    sha256 = "sha256-jE106vWj1uVPmN9iofg/sWZCpSYDyh2/SHwPg5xHatE=";
  };

  vendorHash = "sha256-W5SKD0q3AdIE9Hihnwu6MGoXk1EgBo6ipZaQ73u2tLU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
}
