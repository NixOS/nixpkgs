{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.33.1";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-m7dOgxk1EuyqIuVK4ZDimqZX015Osk5FF+0/SFAkp90=";
  };

  vendorHash = "sha256-T4BPCDYR/f2rInLNytaVibE2hKWsIYqpJw9asY0TbvY=";

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

  meta = {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
}
