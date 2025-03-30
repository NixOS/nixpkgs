{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "lakectl";
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "lakeFS";
    tag = "v${version}";
    hash = "sha256-AYFhkwnlK8RU/HPemJkoZiJ1DCSszIFybJRsUIGhs4g=";
  };

  subPackages = [ "cmd/lakectl" ];
  proxyVendor = true;
  vendorHash = "sha256-p5eHkVbUrcSC4i+R/HGh2nSTIWVkFNiN+TVh10rdWqs=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/treeverse/lakefs/pkg/version.Version=${version}"
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
    if [[ "$versionOutput" == *"lakectl version: ${version}"* ]]; then
      echo "Version check passed!"
    else
      echo "Version check failed!"
      echo "Expected version: 'lakectl version: ${version}'"
      echo "Got version: $versionOutput"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for LakeFS";
    homepage = "https://docs.lakefs.io/reference/cli.html";
    changelog = "https://github.com/treeverse/lakeFS/blob/v${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "lakectl";
  };
}
