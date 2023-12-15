{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ascii-image-converter";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "TheZoraiz";
    repo = "ascii-image-converter";
    rev = "v${version}";
    sha256 = "sha256-svM/TzGQU/QgjqHboy0470+A6p4kR76typ9gnfjfAJk=";
  };

  vendorHash = "sha256-rQS3QH9vnEbQZszG3FOr1P5HYgS63BurCNCFQTTdvZs=";

  meta = with lib; {
    description = "Convert images into ASCII art on the console";
    homepage = "https://github.com/TheZoraiz/ascii-image-converter#readme";
    license = licenses.asl20;
    maintainers = [ maintainers.danth ];
  };
}
