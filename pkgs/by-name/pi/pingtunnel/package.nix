{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pingtunnel";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "esrrhs";
    repo = "pingtunnel";
    rev = finalAttrs.version;
    hash = "sha256-CxRB/RXRA2SkwvnywAgta36TPdUogLS/O93e34IVHK4=";
  };

  vendorHash = "sha256-XC55zV7HTro9kJummsuEbMzFwyV/udbgVCQGa3A9ILU=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pingtunnel
  '';

  meta = {
    description = "Tool that send TCP/UDP traffic over ICMP";
    homepage = "https://github.com/esrrhs/pingtunnel";
    changelog = "https://github.com/esrrhs/pingtunnel/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "pingtunnel";
  };
})
