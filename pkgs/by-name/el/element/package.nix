{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "element";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "element";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-06RDZnie0Lv7i95AwnBGl6PPucuj8pIT6DHW3e3mu1o=";
  };

  vendorHash = "sha256-A4g2rQTaYrA4/0rqldUv7iuibzNINEvx9StUnaN2/Yg=";

  meta = {
    description = "Periodic table on the command line";
    mainProgram = "element";
    homepage = "https://github.com/gennaro-tedesco/element";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.j0hax ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
