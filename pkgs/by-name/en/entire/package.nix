{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "entire";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6/TsSmJ0z72Ta5ZihO06uV4Mik+fFpm8eCa7d5zlq24=";
  };

  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.6" "go 1.25.5"
  '';

  vendorHash = "sha256-rh2VhdwNT5XJYCVjj8tnoY7cacEhc/kcxi0NHYFPYO8=";

  subPackages = [ "cmd/entire" ];

  nativeCheckInputs = [ git ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/entireio/cli/cmd/entire/cli/buildinfo.Version=${finalAttrs.version}"
    "-X=github.com/entireio/cli/cmd/entire/cli/buildinfo.Commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Entire is a new developer platform that hooks into your git workflow to capture AI agent sessions on every push, unifying your code with its context and reasoning";
    homepage = "https://github.com/entireio/cli";
    changelog = "https://github.com/entireio/cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squishykid ];
    mainProgram = "entire";
  };
})
