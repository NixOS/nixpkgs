{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqls";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "lighttiger2505";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xtvm/NVL98dRzQL1id/WwT/NdsnB7qTRVR7jfrRsabY=";
  };

  vendorSha256 = "sha256-sowzyhvNr7Ek3ex4BP415HhHSKnqPHy5EbnECDVZOGw=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.revision=${src.rev}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/lighttiger2505/sqls";
    description = "SQL language server written in Go";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
