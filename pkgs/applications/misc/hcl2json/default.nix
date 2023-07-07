{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kmg483HidFL9mP6jXisLN5VR0dd0xzPXSwqTR8tOCrM=";
  };

  vendorHash = "sha256-ejbCY5S/aeY5Sp+5A20y5kUDY0yxgnMUxtr3UPvtic0=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
