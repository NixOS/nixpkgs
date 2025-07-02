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
  version = "0.2.34";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${version}";
    hash = "sha256-n3fYqtJ80YW4Pqepbo6rkjvV1jeCTWKUdieDey8dz04=";
  };

  vendorHash = "sha256-KphRxVuOE+2Rfjr5jmcm4KqBEwfMtLIvXZxVUplH31U=";

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
