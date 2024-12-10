{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.34.0";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-Ynhom4WX1ME6/uI0HQ83S1DgLYN1HjUxKk5CUL/Fgzk=";
  };

  vendorHash = "sha256-FHvppbAAKW2Nf5GKhMWoMuOgqAp6deOSE61hg7dASqo=";

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

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      nickhu
      techknowlogick
      kashw2
    ];
  };
}
