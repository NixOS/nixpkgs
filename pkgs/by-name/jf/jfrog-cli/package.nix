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
  version = "2.107.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8O11hSt51NXTGAAIuPzpl7b78DqE+xDTFddO9UiSaQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-f2kA1zRMdScMxxJJOX7paUksg9gYKjo1S2FwHeRIVKs=";

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
