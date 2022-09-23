{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "element";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = pname;
    rev = "v${version}";
    sha256 = "gjdcNvYNnxb6hOE/MQjTezZeYGBWTr4E8/Pt8YQv3lY=";
  };

  vendorSha256 = "A4g2rQTaYrA4/0rqldUv7iuibzNINEvx9StUnaN2/Yg=";

  meta = with lib; {
    description = "The periodic table on the command line";
    homepage = "https://github.com/gennaro-tedesco/element";
    license = licenses.asl20;
    maintainers = [ maintainers.j0hax ];
  };
}
