{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "panicparse";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "maruel";
    repo = "panicparse";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vVCPfuLAKPTt5IWI4aNSocZXf9Mct9GoF3Cvgq6lAow=";
  };

  vendorHash = "sha256-eCojW2t8n+xhah5UCshGprj7cZ1Kmh0Z+B2V8Y+wW1w=";

  subPackages = [ "." ];

  meta = {
    description = "Crash your app in style (Golang)";
    homepage = "https://github.com/maruel/panicparse";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "panicparse";
  };
})
