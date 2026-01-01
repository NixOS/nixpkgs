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
<<<<<<< HEAD
  version = "2.67.1";
=======
  version = "2.62.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IRgDCLAClF7Wwmhf1Ba6ulpyDZW3DSZSGj+oIptXImw=";
  };

  vendorHash = "sha256-CRUt2wjPCzIQ2/RDXvwJ5xW3KTJNYf/7Kzkhh4Z9NfI=";
=======
    hash = "sha256-rHu74DHbmy+/1mdsEvvND4bzVzVXfQoSXfJIzPYSq2s=";
  };

  vendorHash = "sha256-neUCgxE7NH6rRKrmjpkzwcCFxYxiqgu5/0b0e/833Ng=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    updateScript = nix-update-script {
      # Fetch versions from GitHub releases to detect pre-releases and
      # avoid updating to them.
      extraArgs = [ "--use-github-releases" ];
    };
  };

<<<<<<< HEAD
  meta = {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gerschtli
      kashw2
    ];
    mainProgram = "supabase";
  };
}
