{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-ZyQpTxWBCU+pmulEXi/Y2PimbNMsUlbEFj8r+gTOTA0=";
  };

  vendorHash = "sha256-96r2UWM5HUF69BOGW6buV6juJEDYoiBPmR5iGNmI5WA=";

  ldflags = [
    "-X=main.Branch=main"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  # fails on darwin with: write unixgram -> <tmpdir>/rsyncd.log: write: message too long
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Tool for extracting metrics from application logs";
    homepage = "https://github.com/google/mtail";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "mtail";
  };
}
