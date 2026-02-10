{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "resgate";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "resgateio";
    repo = "resgate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HQgBWH6dqfmAfKMezUjPbwXif8bqAClns589la2lBVA=";
  };

  vendorHash = "sha256-1yQScWjlqYvFmuqG4TLmImlCjFPrLcYcmZ1a3QUnSXY=";

  meta = {
    description = "Realtime API Gateway used with NATS to build REST, real time, and RPC APIs";
    homepage = "https://resgate.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ farcaller ];
    mainProgram = "resgate";
  };
})
