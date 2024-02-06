{ lib
, fetchFromGitHub
, buildGoModule
, testers
, files-cli
}:

buildGoModule rec {
  pname = "files-cli";
  version = "2.12.28";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${version}";
    hash = "sha256-4YW261qQtbfbX08zuGzr3qH470DaWUDIVaex7qYe2tI=";
  };

  vendorHash = "sha256-w5R7eVrnpcKu0/V2gAeZ7RL6VyA57INcOU31Jhwf1so=";

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

  meta = with lib; {
    description = "Files.com Command Line App for Windows, Linux, and macOS.";
    homepage = "https://developers.files.com";
    license = licenses.mit;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "files-cli";
  };

}
