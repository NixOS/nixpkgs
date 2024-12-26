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
  version = "0.2.33";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tvDjjG8ym1wdQzQSO7T5BkbYbqD1M+EnPSPumbFKRhE=";
  };

  vendorHash = "sha256-SmmuHVf9nuqdT4jqhQDLl5gAHq/3qLKNpgwuwBBNfW4=";

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

  meta = with lib; {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = licenses.mit;
    maintainers = with maintainers; [ nasageek ];
    mainProgram = "supercronic";
  };
}
