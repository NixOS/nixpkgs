{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uni";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    rev = "refs/tags/v${version}";
    hash = "sha256-ociPkuRtpBS+x1zSVNYk8oqAsJZGv31/TUUUlBOYhJA=";
  };

  vendorHash = "sha256-/PvBn2RRYuVpjnrIL1xAcVqAKZuIV2KTSyVtBW1kqj4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    changelog = "https://github.com/arp242/uni/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
    mainProgram = "uni";
  };
}
