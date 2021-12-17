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

  runVend = true;
  vendorSha256 = "JKrBMhzBL1+jlMPudynjOc/ekFiUVaxltyLr4V8QZbg=";

  meta = with lib; {
    description = "Convert images into ASCII art on the console";
    homepage = "https://github.com/TheZoraiz/ascii-image-converter#readme";
    license = licenses.asl20;
    maintainers = [ maintainers.danth ];
  };
}
