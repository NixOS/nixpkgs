{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "jfrog-cli";
  version = "2.120.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ATAnicrp0EwjrT76TN/L0ANX8hm81KN4AQKwMJI07WM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-WC/tcneJa7xjOq9laP1un4BbMp6GIMBiy34DuFiRTIA=";

  checkFlags = "-skip=^(TestReleaseBundle|TestVisibilitySendUsage_RtCurl_E2E)";

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  nativeCheckInputs = [
    nodejs
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

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
