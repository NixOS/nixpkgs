{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "qrcp";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2NbLv5bDg4jiMSM7z3kPcVeHZqOmgfvJ2kJPAMXgn3U=";
  };

  vendorHash = "sha256-owEM11NgWLtP4hqHlaxtWtwDCxCgPkTccq+rKGIN9X4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/claudiodangelis/qrcp/version.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd qrcp \
      --bash <($out/bin/qrcp completion bash) \
      --fish <($out/bin/qrcp completion fish) \
      --zsh <($out/bin/qrcp completion zsh)
  '';

  meta = {
    homepage = "https://qrcp.sh/";
    description = "Transfer files over wifi by scanning a QR code from your terminal";
    longDescription = ''
      qrcp binds a web server to the address of your Wi-Fi network
      interface on a random port and creates a handler for it. The default
      handler serves the content and exits the program when the transfer is
      complete.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "qrcp";
  };
})
