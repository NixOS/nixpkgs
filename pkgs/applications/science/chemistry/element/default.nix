{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "element";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-06RDZnie0Lv7i95AwnBGl6PPucuj8pIT6DHW3e3mu1o=";
  };

  vendorHash = "sha256-A4g2rQTaYrA4/0rqldUv7iuibzNINEvx9StUnaN2/Yg=";

  meta = with lib; {
    description = "Periodic table on the command line";
    mainProgram = "element";
    homepage = "https://github.com/gennaro-tedesco/element";
    license = licenses.asl20;
    maintainers = [ maintainers.j0hax ];
    broken = stdenv.isDarwin;
  };
}
