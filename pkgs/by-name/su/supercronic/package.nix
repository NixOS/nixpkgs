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
  version = "0.2.49";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = "supercronic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vjlsww/YEbG/HJaExH86kyciuTNs6583CFIFf2S8Rzk=";
  };

  vendorHash = "sha256-qsxNAMTHEPtLuedEOAnE+BI65uo4iL620mGz0aveFQc=";

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
