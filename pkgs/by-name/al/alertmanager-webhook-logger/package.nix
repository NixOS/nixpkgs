{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "alertmanager-webhook-logger";
  version = "1.0";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "tomtom-international";
    repo = "alertmanager-webhook-logger";
    hash = "sha256-mJbpDiTwUsFm0lDKz8UE/YF6sBvcSSR6WWLrfKvtri4=";
  };

  vendorHash = "sha256-gKtOoM9TuEIHgvSjZhqWmdexG2zDjlPuM0HjjP52DOI=";

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus) alertmanager; };

  meta = with lib; {
    description = "Generates (structured) log messages from Prometheus AlertManager webhook notifier";
    mainProgram = "alertmanager-webhook-logger";
    homepage = "https://github.com/tomtom-international/alertmanager-webhook-logger";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpds ];
  };
}
