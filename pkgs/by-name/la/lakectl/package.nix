{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "lakectl";
  version = "1.83.0";

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "lakeFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5/2iI5/87x+VJ1MbYw7zPEDeTm1XVuLmSsI6KssRGRE=";
  };

  subPackages = [ "cmd/lakectl" ];
  proxyVendor = true;
  vendorHash = "sha256-UNDIqP79CG2+M8HKkHT1l7X2/Dt6YDTQzADR5T7klUg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/treeverse/lakefs/pkg/version.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    go generate ./pkg/api/apigen ./pkg/auth
  '';

  doInstallCheck = true;

  # custom version test for install phase,
  # versionCheckHook doesn't work as it expects only version to be returned as output, here it's a string with version
  installCheckPhase = ''
    runHook preInstallCheck

    versionOutput=$($out/bin/lakectl --version)
    echo "Version output: $versionOutput"
    if [[ "$versionOutput" == *"lakectl version: ${finalAttrs.version}"* ]]; then
      echo "Version check passed!"
    else
      echo "Version check failed!"
      echo "Expected version: 'lakectl version: ${finalAttrs.version}'"
      echo "Got version: $versionOutput"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for LakeFS";
    homepage = "https://docs.lakefs.io/reference/cli.html";
    changelog = "https://github.com/treeverse/lakeFS/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "lakectl";
  };
})
