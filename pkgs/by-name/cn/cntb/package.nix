{ buildGoModule
, lib
, fetchFromGitHub
}: buildGoModule rec {
  pname = "cntb";
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${version}";
    hash = "sha256-clDIrZdvEy4oO0ZvqDNLJbr4Ij8D5dcyZPxey6zLV6Q=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-IBDVHQe6OOGQ27G7uXKRtavy4tnCvIbL07j969/E9Vg=";

  ldflags = [
    "-X contabo.com/cli/cntb/cmd.version=${src.rev}"
    "-X contabo.com/cli/cntb/cmd.commit=${src.rev}"
    "-X contabo.com/cli/cntb/cmd.date=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "CLI tool for managing your products from Contabo like VPS and VDS";
    mainProgram = "cntb";
    homepage = "https://github.com/contabo/cntb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aciceri ];
  };
}
