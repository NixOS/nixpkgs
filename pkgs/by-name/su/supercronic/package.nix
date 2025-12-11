{
  lib,
  buildGoModule,
  fetchFromGitHub,
  python3,
  bash,
  coreutils,
}:

buildGoModule rec {
  pname = "supercronic";
  version = "0.2.40";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${version}";
    hash = "sha256-20L2GriC+f6bUiJOiUsnvpTEG1J3hp60ry3fSrJt87A=";
  };

  vendorHash = "sha256-a1W/Ah3zPMLvYfQj6uWsHvwjxpLs2vb8E2YYH/RRQvs=";

  excludedPackages = [ "cronexpr/cronexpr" ];

  nativeCheckInputs = [
    python3
    bash
    coreutils
  ];

  postConfigure = ''
    # There are tests that set the shell to various paths
    substituteInPlace cron/cron_test.go --replace /bin/sh ${bash}/bin/sh
    substituteInPlace cron/cron_test.go --replace /bin/false ${coreutils}/bin/false
  '';

  ldflags = [ "-X main.Version=${version}" ];

  meta = {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nasageek ];
    mainProgram = "supercronic";
  };
}
