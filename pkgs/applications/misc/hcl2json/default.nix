{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aYsE4Tmi2h+XiLZH0faoB17UA7xHht8bec5Kud+NLIk=";
  };

  vendorHash = "sha256-Rjpru0SfGm9hdMQwvk8yM/E65YFB0NicaJ7a56/uwLE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
}
