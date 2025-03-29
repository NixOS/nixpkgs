{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.23";

  src = fetchFromGitHub {
    owner = "jaqx0r";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-B/to05/qORplhNyz0s7t/WgpmOJ6UZoKnmJfqaf6Htc=";
  };

  vendorHash = "sha256-jE1tcZJ7TaMC3yegBHE3Zad9sF0EfbHxDA8ffehNL4U=";

  ldflags = [
    "-X=main.Branch=main"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  # fails on darwin with: write unixgram -> <tmpdir>/rsyncd.log: write: message too long
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Tool for extracting metrics from application logs";
    homepage = "https://github.com/jaqx0r/mtail";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "mtail";
  };
}
