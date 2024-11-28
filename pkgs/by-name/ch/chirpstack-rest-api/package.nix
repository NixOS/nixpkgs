{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.10.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-Rqxayn5vcCsvdztfElhRrdxxO3l5SgtckmWQMYey9MA=";
  };

  vendorHash = "sha256-7Qcd7AQjIdp5j7/i7wEZslMiOR5/rJ0HGbo8o7Q035U=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "gRPC API to REST proxy for Chirpstack";
    homepage = "https://www.chirpstack.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stv0g ];
    mainProgram = "chirpstack-rest-api";
  };
}
