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
  version = "2.108.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0n0CZZKj7C3KmNMVTAW4I8Ns9nrjrZQnQ58P+jbUw3U=";
  };

  proxyVendor = true;
  vendorHash = "sha256-4Tia59lRE27rsJC5j/jykb9d88byOcPyDcnkSOwR6h8=";

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
