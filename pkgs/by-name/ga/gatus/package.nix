{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.25.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-mTj3lMdgWlIZO4qxGNyd5il9MXMg2nOBZ6yFQhWKTzM=";
  };

  vendorHash = "sha256-v8fnooABoHxdK2dyTgkmukMdjR73a5p8g20J1a+WYnE=";

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

  meta = with lib; {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
}
