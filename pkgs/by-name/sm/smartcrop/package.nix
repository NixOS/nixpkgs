{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "smartcrop";
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "smartcrop";
    rev = "f1935b108c21d44756141bfebf302dfd7b03fdbe";
    hash = "sha256-3fNDmKR5b6SexG3fBn7uXrtL1gbXrpo8d8boKul1R6Y=";
  };

  vendorHash = "sha256-ov3dHF/NxqxWPaVzddaJSjz3boLpZtIPtvP1iNBtiTc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Find good image crops for arbitrary crop sizes";
    homepage = "https://github.com/muesli/smartcrop";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "smartcrop";
  };
}
