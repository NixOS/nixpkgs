{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-ebl/edMN45oLV1pN6mCaOSgxSSyAugsBP2sQWbIiPTI=";
  };

  vendorHash = "sha256-Y0LOtyRJWOFAQwfg8roisSer0oCxPiaYICE1FY/SEF8=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
}
