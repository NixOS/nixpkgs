{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
  curl,
}:

buildGoModule (finalAttrs: {
  pname = "jfrog-cli";
  version = "2.95.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDnlPZejZ4XypNC6mOS8v1V1onPFVL+AobN8kdqx78I=";
  };

  proxyVendor = true;
  vendorHash = "sha256-IEqE+0jAdCgj0VW8KzwrJpOT2e6RlHUOwbPSKyxE/3Q=";

  checkFlags = "-skip=^TestReleaseBundle";

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  nativeCheckInputs = [
    nodejs
    curl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "jf";
    maintainers = with lib.maintainers; [
      detegr
    ];
  };
})
