{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qrcp";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    rev = version;
    hash = "sha256-MmWBcDtZUDX5IV7XXifBp7KfeRh+0qU4vdfCoMv/UNk=";
  };

  vendorHash = "sha256-lqGPPyoSO12MyeYIuYcqDVHukj7oR3zmHgsS6SxY3yo=";

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
