{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "feed2imap-go";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Necoro";
    repo = "feed2imap-go";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Qtpg8DvIFkba+Do8IwemBF0rt85wS4Tq7yOLsdpQFCs=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/Necoro/feed2imap-go/pkg/version.version=${version}"
    "-X github.com/Necoro/feed2imap-go/pkg/version.commit=nixpkgs"
  ];

  vendorHash = "sha256-WFbfSzU1N2RAOMfCM7wqiAQ6R1HRaT0EfX4KYhstHJU=";
=======
    sha256 = "sha256-zRp/MfRtCgzYFNKoV4IWbORfCy7vaaDgmRvNQ0cICNQ=";
  };

  vendorHash = "sha256-py0totvLLw3kahEtdZkES1t7tZsKBAUS6IMTcn847kE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
