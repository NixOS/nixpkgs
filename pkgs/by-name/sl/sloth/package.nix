{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sloth";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${version}";
    hash = "sha256-VwktgkJjJ1tMlGZwhr1bvaCDiatZKlylFY//8YpXPYw=";
  };

  vendorHash = "sha256-5TTOQ9u7BDrwGa2X8y6d0C6Vb92ZBk451V0kpsUhl9c=";

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
