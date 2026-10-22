{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule {
  pname = "go-autoconfig";
  version = "0.0.1-unstable-2022-08-03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "savely-krasovsky";
    repo = "go-autoconfig";
    rev = "b1b182202da82cc881dccd715564853395d4f76a";
    hash = "sha256-Rbg6Ghp5NdcLSLSIhwwFFMKmZPWsboDyHCG6ePqSSZA=";
  };

  vendorHash = "sha256-pI2iucrt7XLLZNOz364kOEulXxPdvJp92OewqnkQEO4=";

  postInstall = ''
    cp -r templates $out/
  '';

  meta = {
    description = "IMAP/SMTP autodiscover feature for Thunderbird, Apple Mail and Microsoft Outlook";
    homepage = "https://github.com/savely-krasovsky/go-autoconfig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "go-autoconfig";
  };
}
