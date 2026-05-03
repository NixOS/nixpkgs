{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jfrog-cli";
  version = "2.103.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7IJ76xpaM3V964dYOu4mZCxbx66e5976QYNddNoyiJk=";
  };

  proxyVendor = true;
  vendorHash = "sha256-vtLsjbj1cb6AmV8EM+9cghlcL9nVDMeC8Au3sMuT91c=";

  checkFlags = "-skip=^(TestReleaseBundle|TestVisibilitySendUsage_RtCurl_E2E)";

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  nativeCheckInputs = [ nodejs ];

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
