{
  buildGoModule,
  fetchFromGitHub,
  lib,
  cf-terraforming,
  testers,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "cf-terraforming";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf-terraforming";
    rev = "v${version}";
    sha256 = "sha256-fJ3TgdEv9vk5HUUG+0cqYuA4fjXq5Smjf/KAILT9/AU=";
  };

  vendorHash = "sha256-NNeJ6QfTV8X3WIFge+Ln38ym9uagLl3IpNWuPqMjeBA=";
  ldflags = [
    "-X github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=${version}"
  ];

  # The test suite insists on downloading a binary release of Terraform from
  # Hashicorp at runtime, which isn't going to work in a nix build
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = cf-terraforming;
    command = "cf-terraforming version";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cf-terraforming \
      --bash <($out/bin/cf-terraforming completion bash) \
      --fish <($out/bin/cf-terraforming completion fish) \
      --zsh <($out/bin/cf-terraforming completion zsh)
  '';

  meta = with lib; {
    description = "Command line utility to facilitate terraforming your existing Cloudflare resources";
    homepage = "https://github.com/cloudflare/cf-terraforming/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ benley ];
    mainProgram = "cf-terraforming";
  };
}
