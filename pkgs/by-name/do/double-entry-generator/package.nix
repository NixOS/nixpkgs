{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "double-entry-generator";
  version = "2.11.0";
  src = fetchFromGitHub {
    owner = "deb-sig";
    repo = "double-entry-generator";
    hash = "sha256-tHJwn1G/2wySnKpF+P0tyOu3mYk8zD9D301kxrWaWws=";
    rev = "v${version}";
  };

  vendorHash = "sha256-CJ+mfH9qJXYhicxrL9+i8H6CVKZua40D1/Sg3vWQs68=";

  excludedPackages = [ "hack" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/deb-sig/double-entry-generator/pkg/version.VERSION=${version}"
    "-X=github.com/deb-sig/double-entry-generator/pkg/version.REPOROOT=github.com/deb-sig/double-entry-generator"
    "-X=github.com/deb-sig/double-entry-generator/pkg/version.COMMIT=${src.rev}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    touch build-local
    ln -s $out/bin ./
    make SHELL=bash GIT_COMMIT= VERSION= DOCKER_LABELS= -o test-go test

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Rule-based double-entry bookkeeping importer (from Alipay/WeChat/Huobi etc. to Beancount/Ledger)";
    homepage = "https://github.com/deb-sig/double-entry-generator";
    license = licenses.asl20;
    maintainers = with maintainers; [ rennsax ];
    mainProgram = "double-entry-generator";
  };
}
