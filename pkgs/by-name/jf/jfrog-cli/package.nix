{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.78.10";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${version}";
    hash = "sha256-o3H+onnvGFGxUtFRYFHmrEQ5EqQCGP8n/NdqdEHNj84=";
  };

  proxyVendor = true;
  vendorHash = "sha256-jzjYFnctUwQUVC59JIsrHTIWCqYiZTurNFLn9zuM+18=";

  checkFlags = "-skip=^TestReleaseBundle";

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
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "jf";
    maintainers = with lib.maintainers; [
      detegr
    ];
  };
}
