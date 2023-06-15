{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "feed2imap-go";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Necoro";
    repo = "feed2imap-go";
    rev = "v${version}";
    sha256 = "sha256-Qtpg8DvIFkba+Do8IwemBF0rt85wS4Tq7yOLsdpQFCs=";
  };

  vendorHash = "sha256-WFbfSzU1N2RAOMfCM7wqiAQ6R1HRaT0EfX4KYhstHJU=";

  # The print-cache tool is not an end-user tool (https://github.com/Necoro/feed2imap-go/issues/94)
  postInstall = ''
    rm -f $out/bin/print-cache
  '';

  meta = with lib; {
    description = "Uploads rss feeds as e-mails onto an IMAP server";
    homepage = "https://github.com/Necoro/feed2imap-go";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nomeata ];
  };
}
