{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  supabase-cli,
  nix-update-script,
}:

buildGoModule rec {
  pname = "supabase-cli";
  version = "2.47.2";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-o9UtQuBPQeq9coc+0cl3HKyA2SRkqlptVwdLwsvRutw=";
  };

  vendorHash = "sha256-n8u4roDibDTRFeqbsO/H1NqFSGaJrVPewdt4nQPmoRE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/supabase/cli/internal/utils.Version=${version}"
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      gerschtli
      kashw2
    ];
    mainProgram = "supabase";
  };
}
