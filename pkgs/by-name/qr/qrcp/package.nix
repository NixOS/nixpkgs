{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "qrcp";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "claudiodangelis";
    repo = "qrcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1b+Npxoih41KIXsMCP3v5CXrjD6Tc7vssAcBi749Th8=";
  };

  vendorHash = "sha256-caWENdKmZCuvXkw4jAABYDmyEr6+LvZc0glpI83XhdM=";

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
