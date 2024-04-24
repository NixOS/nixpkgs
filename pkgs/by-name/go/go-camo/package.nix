{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-camo";
  version = "2.4.12";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rlzAx6xjV4JR3RDL+Kr2ghN3qpfIRqVZ5z/SyDBBaIc=";
  };

  vendorHash = "sha256-iyZNOooPH1jvT+S9/ETRoXsTwXUIUi1UKmDzhB7NRuE=";

  ldflags = [ "-s" "-w" "-X=main.ServerVersion=${version}" ];

  preCheck = ''
    # requires network access
    rm pkg/camo/proxy_{,filter_}test.go
  '';

  meta = with lib; {
    description = "A camo server is a special type of image proxy that proxies non-secure images over SSL/TLS";
    homepage = "https://github.com/cactus/go-camo";
    changelog = "https://github.com/cactus/go-camo/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "go-camo";
    maintainers = with maintainers; [ viraptor ];
  };
}
