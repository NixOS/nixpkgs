{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.72.2";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vu57V6OiMZjR+g0afeLEkQcwGA0e8PZzYAJjR3/wNoI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-BSLBXHcowF2iVS/fMR3UIIdpbuLDgsPXYV4WK/oeHB4=";

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
