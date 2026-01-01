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
    repo = "resgate";
    rev = "v${version}";
    hash = "sha256-HQgBWH6dqfmAfKMezUjPbwXif8bqAClns589la2lBVA=";
  };

  vendorHash = "sha256-1yQScWjlqYvFmuqG4TLmImlCjFPrLcYcmZ1a3QUnSXY=";

<<<<<<< HEAD
  meta = {
    description = "Realtime API Gateway used with NATS to build REST, real time, and RPC APIs";
    homepage = "https://resgate.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ farcaller ];
=======
  meta = with lib; {
    description = "Realtime API Gateway used with NATS to build REST, real time, and RPC APIs";
    homepage = "https://resgate.io";
    license = licenses.mit;
    maintainers = with maintainers; [ farcaller ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "resgate";
  };
}
