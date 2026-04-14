{
  lib,
  buildGoModule,
  fetchFromGitHub,
  python3,
  bash,
  coreutils,
}:

buildGoModule (finalAttrs: {
  pname = "supercronic";
  version = "0.2.44";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xtTQ5T+/kVnh4sjIN/N9HN9MeEd2ekAzSkvYdei0dKA=";
  };

  vendorHash = "sha256-azjkMzmAhAKyHx/43cP0kpgo0mKM8Yh+LWHiR7audQw=";

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

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  meta = {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nasageek ];
    mainProgram = "supercronic";
  };
})
