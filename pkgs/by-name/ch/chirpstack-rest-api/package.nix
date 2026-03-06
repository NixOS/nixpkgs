{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "chirpstack-rest-api";
  version = "4.16.1";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-rest-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-utXayqQGlBYzmf7xW+s1Fh4oRhpBdfnV5g73X2ILKko=";
  };

  vendorHash = "sha256-JnQaClgU+Yyz07lELoEyLYHLJwcmET5SLci2XQoFGKc=";

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
})
