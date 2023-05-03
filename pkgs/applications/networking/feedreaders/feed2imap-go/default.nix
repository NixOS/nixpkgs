{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "feed2imap-go";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Necoro";
    repo = "feed2imap-go";
    rev = "v${version}";
    sha256 = "sha256-zRp/MfRtCgzYFNKoV4IWbORfCy7vaaDgmRvNQ0cICNQ=";
  };

  vendorHash = "sha256-py0totvLLw3kahEtdZkES1t7tZsKBAUS6IMTcn847kE=";

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
