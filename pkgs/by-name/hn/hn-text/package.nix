{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "hn-text";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "hn-text";
    rev = "v${version}";
    hash = "sha256-YoPdYuNlWrLITyd2XeCOeGy70Ews1rvtOQzYZAQTI+Y=";
  };

  vendorHash = "sha256-lhghteKspXK1WSZ3dVHaTgx2BRx9S7yGNbvRYZKeA+s=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, easy-to-use and distraction-free Hacker News terminal client";
    homepage = "https://github.com/piqoni/hn-text";
    license = lib.licenses.mit;
    mainProgram = "hn-text";
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
}
