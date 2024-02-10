{ lib
, fetchFromGitHub
, buildGoModule
, testers
, files-cli
}:

buildGoModule rec {
  pname = "files-cli";
  version = "2.12.30";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${version}";
    hash = "sha256-V0oQ43ZTgzXjp+jZvF0UxfjU7vhbvKuDG2rBvB1pEOk=";
  };

  vendorHash = "sha256-OKNwYQCiB07cpnmQmJR0OJ3gX4VtXEcCPzsINEHj8Zg=";

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
