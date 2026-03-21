{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jqp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = "jqp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pCWvmX6VvcKlPoMkVGfVkPTOx+sE+v2ey39/jOhgtsg=";
  };

  vendorHash = "sha256-FBAf+np/8Zy+p1mPyP1O8md2sAkkeiFu60UYtkszG8g=";

  subPackages = [ "." ];

  meta = {
    description = "TUI playground to experiment with jq";
    mainProgram = "jqp";
    homepage = "https://github.com/noahgorstein/jqp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
