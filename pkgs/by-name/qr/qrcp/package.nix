{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qrcp";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    tag = "v${version}";
    hash = "sha256-OLoGM9kG5k8iyCBQ8PW0i8WiSOASkW9S8YI1iRSb0Ic=";
  };

  vendorHash = "sha256-BkR+hIbxIFuf3b4kHVkfC5Ex6/O7CVaFolKlcDPJ7YY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/claudiodangelis/qrcp/version.version=${version}"
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
}
