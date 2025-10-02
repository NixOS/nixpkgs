{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "badrobot";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "badrobot";
    rev = "v${version}";
    sha256 = "sha256-U3b5Xw+GjnAEXteivztHdcAcXx7DYtgaUbW5oax0mIk=";
  };
  vendorHash = "sha256-oYdkCEdrw1eE5tnKveeJM3upRy8hOVc24JNN1bLX+ec=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/controlplaneio/badrobot/cmd.version=v${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd badrobot \
      --bash <($out/bin/badrobot completion bash) \
      --fish <($out/bin/badrobot completion fish) \
      --zsh <($out/bin/badrobot completion zsh)
  '';

  meta = {
    homepage = "https://github.com/controlplaneio/badrobot";
    changelog = "https://github.com/controlplaneio/badrobot/blob/v${version}/CHANGELOG.md";
    description = "Operator Security Audit Tool";
    mainProgram = "badrobot";
    longDescription = ''
      Badrobot is a Kubernetes Operator audit tool. It statically analyses
      manifests for high risk configurations such as lack of security
      restrictions on the deployed controller and the permissions of an
      associated clusterole. The risk analysis is primarily focussed on the
      likelihood that a compromised Operator would be able to obtain full
      cluster permissions.
    '';
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ jk ];
  };
}
