{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.76.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    tag = "v${version}";
    hash = "sha256-DZJLIIigX4/gzGaVVhyJmk+TN6wnNlH+NWkB6dc0aoU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Ouz1nac3+u8AYzqLaax6Nw6qunTN/hCRjEf9koDM75A=";

  checkFlags = "-skip=^TestReleaseBundle";

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  nativeCheckInputs = [ nodejs ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = with maintainers; [
      detegr
      aidalgol
    ];
  };
}
