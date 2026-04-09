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
  version = "2.88.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v4H+sABhR53vKreq+yX9iJK7+5xlM+KXcuEUawDFZto=";
  };

  vendorHash = "sha256-5DWsFaZ700FGb6AnqTs3ewhieHuTl4SrnQHdbiNZBY4=";

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
