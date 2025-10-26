{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sloth";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${version}";
    hash = "sha256-f9AsHzi2Z4qHbr2uSHU0+Jt6FwFwgWQPFTs2rlJWB6U=";
  };

  vendorHash = "sha256-+WnKSt0Xa9rLZU+ce2vOxW2wlhFLzd2H82b6Vpwe+AQ=";

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
