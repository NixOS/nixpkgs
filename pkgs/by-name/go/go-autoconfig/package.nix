{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-autoconfig";
  version = "unstable-2022-08-03";

  src = fetchFromGitHub {
    owner = "L11R";
    repo = pname;
    rev = "b1b182202da82cc881dccd715564853395d4f76a";
    sha256 = "sha256-Rbg6Ghp5NdcLSLSIhwwFFMKmZPWsboDyHCG6ePqSSZA=";
  };

  vendorHash = "sha256-pI2iucrt7XLLZNOz364kOEulXxPdvJp92OewqnkQEO4=";

  postInstall = ''
    cp -r templates $out/
  '';

  meta = with lib; {
    description = "IMAP/SMTP autodiscover feature for Thunderbird, Apple Mail and Microsoft Outlook";
    homepage = "https://github.com/L11R/go-autoconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    mainProgram = "go-autoconfig";
  };
}
