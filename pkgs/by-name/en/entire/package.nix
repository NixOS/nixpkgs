{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  stdenv,
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

  vendorHash = "sha256-rh2VhdwNT5XJYCVjj8tnoY7cacEhc/kcxi0NHYFPYO8=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.6" "go 1.25.5"
  '';

  subPackages = [ "cmd/entire" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd entire \
      --bash <($out/bin/entire completion bash) \
      --fish <($out/bin/entire completion fish) \
      --zsh <($out/bin/entire completion zsh)
  '';

  meta = {
    description = "CLI tool that captures AI agent sessions alongside git commits";
    longDescription = ''
      Entire hooks into your git workflow to capture AI agent sessions on every
      push. Sessions are indexed alongside commits, creating a searchable record
      of how code was written in your repo.
    '';
    homepage = "https://github.com/entireio/cli";
    changelog = "https://github.com/entireio/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "entire";
  };
})
