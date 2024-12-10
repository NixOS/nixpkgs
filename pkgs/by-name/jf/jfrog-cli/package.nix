{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGo123Module rec {
  pname = "jfrog-cli";
  version = "2.71.0";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-hblOe6YMlfWBVvWD5MKEKvAB55jUx98OMeqFDdgVrmM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-px+eXSIOe3v4iNBibXAtcFMROrHq6YYJIHbCC7nhNS4=";

  postPatch = ''
    # Patch out broken test cleanup.
    substituteInPlace artifactory_test.go \
      --replace-fail \
      'deleteReceivedReleaseBundle(t, "cli-tests", "2")' \
      '// deleteReceivedReleaseBundle(t, "cli-tests", "2")'
  '';

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
