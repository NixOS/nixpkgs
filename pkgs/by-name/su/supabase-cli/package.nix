{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "supabase-cli";
  version = "2.122.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lJZvgvoqwoWBDD0HyFR/Qmx9D2DKVHTF69YnhIUHsPQ=";
  };

  # Supabase is in the process of porting the CLI to TS, for now we continue with the Go cli.
  sourceRoot = "${finalAttrs.src.name}/apps/cli-go";

  vendorHash = "sha256-quUmyr0zzBnJeJLQH1MkPvgUP3EpfZSNo1w5/WPeN7U=";

  ldflags = [
    "-s"
    "-X=github.com/supabase/cli/internal/utils.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # Root Go package does not have any tests.

  postPatch = ''
    substituteInPlace cmd/root.go \
      --replace-fail 'rootCmd.CompletionOptions.DisableDefaultCmd = true' \
                     'rootCmd.CompletionOptions.DisableDefaultCmd = false'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    mv $out/bin/{cli,supabase}

    installShellCompletion --cmd supabase \
      --bash <($out/bin/supabase completion bash) \
      --fish <($out/bin/supabase completion fish) \
      --zsh <($out/bin/supabase completion zsh)
  '';

  passthru.updateScript = nix-update-script {
    # Fetch versions from GitHub releases to detect pre-releases and
    # avoid updating to them.
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerschtli
      kashw2
      yuannan
    ];
    mainProgram = "supabase";
  };
})
