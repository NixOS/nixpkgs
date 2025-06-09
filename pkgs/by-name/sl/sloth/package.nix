{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sloth";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${version}";
    hash = "sha256-qyDKM5Y8wRvqFE9rqnPePBvi/1UwR4vDRQRVTxPc6Ug=";
  };

  vendorHash = "sha256-hXDwHKxmrpGR6cbHns9rARu87DqODqr8q25Iv1qFqrA=";

  subPackages = [ "cmd/sloth" ];

  meta = {
    description = "Easy and simple Prometheus SLO (service level objectives) generator";
    homepage = "https://sloth.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = lib.platforms.unix;
    mainProgram = "sloth";
  };
}
