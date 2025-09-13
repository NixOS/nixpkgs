{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  replaceVars,
}:

buildGoModule rec {
  pname = "ent-go";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-rKGzYOdNaSbFyHIuytuppYjpiTz1/tcvXel1SjtwEhA=";
  };

  vendorHash = "sha256-ec5tA9TsDKGnHVZWilLj7bdHrd46uQcNQ8YCK/s6UAY=";

  patches = [
    # patch in version information so we don't get "version = "(devel)";"
    (replaceVars ./ent_version.patch {
      inherit version;
      sum = src.outputHash;
    })
  ];

  subPackages = [ "cmd/ent" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ent \
      --bash <($out/bin/ent completion bash) \
      --fish <($out/bin/ent completion fish) \
      --zsh <($out/bin/ent completion zsh)
  '';

  meta = {
    description = "Entity framework for Go";
    homepage = "https://entgo.io/";
    changelog = "https://github.com/ent/ent/releases/tag/v${version}";
    downloadPage = "https://github.com/ent/ent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "ent";
  };
}
