{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-bindata,
  go-bindata-assetfs,
}:

buildGoModule rec {
  pname = "openwhisk-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "openwhisk-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-SdsfRuN4tsuTObETrES8VOrn2jgz3SucMXKvyUuuZYs=";
  };

  nativeBuildInputs = [
    go-bindata
    go-bindata-assetfs
  ];

  preBuild = ''
    go-bindata -pkg wski18n -o wski18n/i18n_resources.go wski18n/resources
    go mod tidy
  '';

  vendorHash = "sha256-FPlJZ5vz4fxjJ5yL4W21rELPSKrNmb3dXjkY4vzT1hQ=";
  proxyVendor = true;

  buildPhase = ''
    runHook preBuild
    go build -o $GOPATH/bin/wsk
    runHook postBuild
  '';

  meta = {
    description = "Apache OpenWhisk Command Line Interface";
    homepage = "https://github.com/apache/openwhisk-cli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "wsk";
    changelog = "https://github.com/apache/openwhisk-cli/releases/tag/${version}";
  };
}
