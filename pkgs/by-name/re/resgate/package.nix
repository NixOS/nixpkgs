{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "resgate";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "resgateio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HQgBWH6dqfmAfKMezUjPbwXif8bqAClns589la2lBVA=";
  };

  vendorHash = "sha256-1yQScWjlqYvFmuqG4TLmImlCjFPrLcYcmZ1a3QUnSXY=";

  meta = with lib; {
    description = "Realtime API Gateway used with NATS to build REST, real time, and RPC APIs";
    homepage = "https://resgate.io";
    license = licenses.mit;
    maintainers = with maintainers; [ farcaller ];
    mainProgram = "resgate";
  };
}
