{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  supabase-cli,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "supabase-cli";
  version = "2.98.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BDmd9SXHe5dYvn37XNweFUqKjF4LkiNUeeAyV6nd4ZA=";
  };

  vendorHash = "sha256-5HP9NMd0ByepiJOU3G9fNcz6XYFl71Pm0ZZE9Qg94vo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/supabase/cli/internal/utils.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  doCheck = false; # tests are trying to connect to localhost

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/{cli,supabase}

    installShellCompletion --cmd supabase \
      --bash <($out/bin/supabase completion bash) \
      --fish <($out/bin/supabase completion fish) \
      --zsh <($out/bin/supabase completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = supabase-cli;
    };
    updateScript = nix-update-script {
      # Fetch versions from GitHub releases to detect pre-releases and
      # avoid updating to them.
      extraArgs = [ "--use-github-releases" ];
    };
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
