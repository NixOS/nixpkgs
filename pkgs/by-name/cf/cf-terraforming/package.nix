{
  buildGoModule,
  fetchFromGitHub,
  lib,
  cf-terraforming,
  testers,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "cf-terraforming";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf-terraforming";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jq0xBmn+ZGYF6Yup/82wVYgtuIs9RcPHviGxj9JpTF0=";
  };

  vendorHash = "sha256-7/VRs7BEFLCx7sqIbOFA7b7tQwlpgzeWYUdgankHNCo=";
  ldflags = [
    "-X github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=${finalAttrs.version}"
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

  meta = {
    description = "Command line utility to facilitate terraforming your existing Cloudflare resources";
    homepage = "https://github.com/cloudflare/cf-terraforming/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ benley ];
    mainProgram = "cf-terraforming";
  };
})
