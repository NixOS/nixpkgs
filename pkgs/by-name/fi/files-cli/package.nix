{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  files-cli,
}:

buildGoModule (finalAttrs: {
  pname = "files-cli";
  version = "2.15.282";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2N4vftX3AZwxbebEGhc6LKkQXovv/y4JNKLNy3CpaU8=";
  };

  vendorHash = "sha256-kP8YuqtrqmE3m4ACLIsSzXNj0AtmYdLoK9w1KmjExJA=";

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
