{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sshm";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Gu1llaum-3";
    repo = "sshm";
    tag = version;
    hash = "sha256-MD02BMWPmkJNFcXa+KCAupTAQtuaxOXgvKfvhbGZ4kc=";
  };

  vendorHash = "sha256-aU/+bxcETs/Jq5FVAdiioyuc1AufvWeiqFQ7uo1cK1k=";

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Gu1llaum-3/sshm/cmd.AppVersion=${version}"
  ];

  meta = {
    description = "Terminal UI to manage and connect to SSH hosts";
    mainProgram = "sshm";
    homepage = "https://github.com/Gu1llaum-3/sshm";
    changelog = "https://github.com/Gu1llaum-3/sshm/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cedev-1 ];
  };
}
