{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGo126Module (finalAttrs: {
  pname = "scaleway-cli";
  version = "2.58.3";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CKsEPVzAYYQE+g3PTqiWKh+I7c2LOU9logpPIabUp2E=";
  };

  vendorHash = "sha256-tQcl40u8otGohEguPJCTk6JuuWlLB4hrdSsNPQ1ygIw=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.src.tag}"
    "-X main.GitCommit=${finalAttrs.src.rev}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=1970-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/scw"
    "commands/..."
    "core/..."
    "internal/..."
  ];

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [
    # This subtest hardcodes a go-humanize relative-time string ("35 years ago")
    # for a fixed 1990 date instead of computing it, so it breaks once enough
    # wall-clock time passes (now "36 years ago"). go-humanize truncates the
    # elapsed time by a fixed 360-day year (Year = 12*Month, Month = 30*Day), so
    # diff/Year rolled 35 -> 36 on 2026-05-12. Upstream keeps bumping the
    # literal by hand rather than fixing it, so skip the time-dependent subtest.
    "-skip=^TestMarshal/structWithMapsInSection$"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/scw autocomplete script basename=scw shell=bash >scw.bash
    $out/bin/scw autocomplete script basename=scw shell=fish >scw.fish
    echo '#compdef scw' >scw.zsh
    $out/bin/scw autocomplete script basename=scw shell=zsh >>scw.zsh
    installShellCompletion scw.{bash,fish,zsh}
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command Line Interface for Scaleway";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nickhu
      techknowlogick
      kashw2
    ];
    mainProgram = "scw";
  };
})
