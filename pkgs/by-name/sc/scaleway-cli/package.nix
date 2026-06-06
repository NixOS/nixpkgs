{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-bLttAE8IXTeIZ70wxBGxwozI2DVrdFnHdrCS3PL9UHA=";
  };

  vendorHash = "sha256-ivjTL/eiQmj8228VYlgoRzjw9pt6QiwnsXKyjIXfc3M=";

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
    "-X main.Version=${version}"
    "-X main.GitCommit=ref/tags/${version}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=unknown"
  ];

  doCheck = true;

  checkFlags = [
    # This subtest hardcodes a go-humanize relative-time string ("35 years ago")
    # for a fixed 1990 date instead of computing it, so it breaks once enough
    # wall-clock time passes (now "36 years ago"). go-humanize truncates the
    # elapsed time by a fixed 360-day year (Year = 12*Month, Month = 30*Day), so
    # diff/Year rolled 35 -> 36 on 2026-05-12. Upstream keeps bumping the
    # literal by hand rather than fixing it, so skip the time-dependent subtest.
    "-skip=^TestMarshal/structWithMapsInSection$"
  ];

  # Some tests require access to scaleway's API, failing when sandboxed
  preCheck = ''
    substituteInPlace core/bootstrap_test.go \
      --replace-warn "TestInterruptError" "SkipInterruptError"
    substituteInPlace internal/e2e/errors_test.go \
      --replace-warn "TestStandardErrors" "SkipStandardErrors"
    substituteInPlace internal/e2e/human_test.go \
      --replace-warn "TestTestCommand" "SkipTestCommand" \
      --replace-warn "TestHumanCreate" "SkipHumanCreate" \
      --replace-warn "TestHumanList" "SkipHumanList" \
      --replace-warn "TestHumanUpdate" "SkipHumanUpdate" \
      --replace-warn "TestHumanGet" "SkipHumanGet" \
      --replace-warn "TestHumanDelete" "SkipHumanDelete"
    substituteInPlace internal/e2e/sdk_errors_test.go \
      --replace-warn "TestSdkStandardErrors" "SkipSdkStandardErrors"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/scw --help

    runHook postInstallCheck
  '';

  meta = {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nickhu
      techknowlogick
      kashw2
    ];
  };
}
