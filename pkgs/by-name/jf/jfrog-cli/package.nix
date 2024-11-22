{ lib
, buildGoModule
, fetchFromGitHub
, nodejs
, nix-update-script
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.71.4";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-pC56OlSo05nMH+Adkg1v0Lba7Vd+bXeHRP4+Phvhlu8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-d1VloSjvXAt10MsZwVJ0Fkg9pN+tcOE5vURy7hatg30=";

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
    maintainers = with maintainers; [ detegr aidalgol ];
  };
}
