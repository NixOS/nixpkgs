{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  files-cli,
}:

buildGoModule rec {
  pname = "files-cli";
  version = "2.15.195";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${version}";
    hash = "sha256-tr1l+5JcGIKsT4EvoYM4Nb9KS8DEoSiFRANNSb4lKBY=";
  };

  vendorHash = "sha256-ctld8euKWNwmfk9qfwSAdkBeuPGcklbIBaIs+r9nHT4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/files-cli --help

    runHook postInstallCheck
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = files-cli;
      command = "files-cli -v";
      version = "files-cli version ${version}";
    };
  };

  meta = {
    description = "Files.com Command Line App for Windows, Linux, and macOS";
    homepage = "https://developers.files.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "files-cli";
  };

}
