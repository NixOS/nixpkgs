{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  curl,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jfrog-cli";
  version = "2.102.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FcmwlK9HplSqlDdCEJP4OBvvyFYcBrik0Vt6yu6ik8k=";
  };

  proxyVendor = true;
  vendorHash = "sha256-JJVp4jlz26Je2dx8XnPPwd5hNbZDMOx2dO9y9v3IMeY=";

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
