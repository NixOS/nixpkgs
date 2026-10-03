{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "sshsrv";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Crosse";
    repo = "sshsrv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lNt5ftvhNYGeFo0w4Pzj3o3EXzTAVAOPdSGXNSQY9aw=";
  };

  vendorHash = "sha256-snqiThNkQfNJGbpFnOf4ab8oRFzW1NAChFmALUTCzEY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Connect to SSH servers using DNS SRV records";
    homepage = "https://github.com/Crosse/sshsrv";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ptman ];
    mainProgram = "sshsrv";
  };
})
