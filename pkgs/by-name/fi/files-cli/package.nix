{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  files-cli,
}:

buildGoModule (finalAttrs: {
  pname = "files-cli";
  version = "2.15.241";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bhRsRZFfbBs6RLmh5FWVNv3UdD60Bd6xEOcCgpS+GMk=";
  };

  vendorHash = "sha256-PTEE+qtNf6ZFTW4CY7zGT5D2G+kXIk4aWNSR37F5TE0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
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
      version = "files-cli version ${finalAttrs.version}";
    };
  };

  meta = {
    description = "Files.com Command Line App for Windows, Linux, and macOS";
    homepage = "https://developers.files.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "files-cli";
  };

})
