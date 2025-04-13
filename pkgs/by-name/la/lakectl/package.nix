{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lakectl";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "lakeFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fqjVufkmO2JOPyS1/dLx0RIY5BLvvwvKrJFkV1LN53I=";
  };

  subPackages = [ "cmd/lakectl" ];
  proxyVendor = true;
  vendorHash = "sha256-vg2x3QRU0RGq6GtqZU/YBtHAvj5shJtmPFrxx1/HppQ=";

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
