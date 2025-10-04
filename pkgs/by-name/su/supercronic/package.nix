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
  version = "0.2.35";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${version}";
    hash = "sha256-SGW/G9Ud0xsNwD+EXDegh6cGAr4cWeoah7IY6yTREWo=";
  };

  vendorHash = "sha256-q2uH9kY0s1UM2uy6F/x1S0RqIfqXpV5KxnHJLLoAjZY=";

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
