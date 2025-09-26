{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "chirpstack-rest-api";
  version = "4.14.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${version}";
    hash = "sha256-DHDrnChRikVDJhdCcoHlFn3sYfjEvWpzUsMkuIoqQiw=";
  };

  vendorHash = "sha256-BthdLFhzrAiZTI/afsNgKhgCj1QQHabU37sH9ovIDdU=";

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
