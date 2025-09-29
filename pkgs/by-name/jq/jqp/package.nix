{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = "jqp";
    rev = "v${version}";
    sha256 = "sha256-pCWvmX6VvcKlPoMkVGfVkPTOx+sE+v2ey39/jOhgtsg=";
  };

  vendorHash = "sha256-FBAf+np/8Zy+p1mPyP1O8md2sAkkeiFu60UYtkszG8g=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "TUI playground to experiment with jq";
    mainProgram = "jqp";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
