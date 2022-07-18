{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ascii-image-converter";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "TheZoraiz";
    repo = "ascii-image-converter";
    rev = "v${version}";
    sha256 = "5Sa9PqhoJ/LCAHrymqVCO4bI39mQeVa4xv1z235Cxvg=";
  };

  vendorSha256 = "rQS3QH9vnEbQZszG3FOr1P5HYgS63BurCNCFQTTdvZs=";

  meta = with lib; {
    description = "Convert images into ASCII art on the console";
    homepage = "https://github.com/TheZoraiz/ascii-image-converter#readme";
    license = licenses.asl20;
    maintainers = [ maintainers.danth ];
  };
}
