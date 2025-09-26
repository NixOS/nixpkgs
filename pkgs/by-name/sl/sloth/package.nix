{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sloth";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${version}";
    hash = "sha256-rgDTLbNhs9CD+VHEo2+eLGh9amhWg/TksbXTvxvp7j8=";
  };

  vendorHash = "sha256-8p6NYgIK5Gc+gEkNkn1nL4t605xzhF3nS8UYX+AT/Ag=";

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
