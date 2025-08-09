{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "feed2imap-go";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Necoro";
    repo = "feed2imap-go";
    rev = "v${version}";
    sha256 = "sha256-7ce2G2t+7P+7Ga+BLyGF4lW4BB2yaE9rV/dxBFvdPEU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Necoro/feed2imap-go/pkg/version.version=${version}"
    "-X github.com/Necoro/feed2imap-go/pkg/version.commit=nixpkgs"
  ];

  vendorHash = "sha256-3z3SPJ5xsz0LRjzOeOQnAuCpIAAtEkn9itoslvJhmTo=";

  # The print-cache tool is not an end-user tool (https://github.com/Necoro/feed2imap-go/issues/94)
  postInstall = ''
    rm -f $out/bin/print-cache
  '';

  meta = with lib; {
    description = "Uploads rss feeds as e-mails onto an IMAP server";
    mainProgram = "feed2imap-go";
    homepage = "https://github.com/Necoro/feed2imap-go";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nomeata ];
  };
}
