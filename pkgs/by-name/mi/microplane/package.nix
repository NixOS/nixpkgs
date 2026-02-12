{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "microplane";
  version = "0.0.37";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-TwNwXMQGsD9Kx5uH+kAOGlwCF1t1oAefVCbKmRtZ4Vc=";
  };

  vendorHash = "sha256-fF1tHhOtw1ms6447lna40NrZT3ItpiQu31Y0psXt1/Y=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = {
    description = "CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dbirks ];
  };
})
