{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ascii-image-converter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "TheZoraiz";
    repo = "ascii-image-converter";
    rev = "v${version}";
    sha256 = "DitJnWIz1Dt9yXtyQp/z738IAmG4neYmfc49Wdjos7Q=";
  };

  vendorSha256 = "sha256-pKgukWKF4f/kLASjh8aKU7x9UBW/H+4C/02vxmh+qOU=";

  meta = with lib; {
    description = "Convert images into ASCII art on the console";
    homepage = "https://github.com/TheZoraiz/ascii-image-converter#readme";
    license = licenses.asl20;
    maintainers = [ maintainers.danth ];
  };
}
