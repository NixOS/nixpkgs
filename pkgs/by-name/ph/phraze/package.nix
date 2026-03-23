{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  phraze,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phraze";
  version = "0.3.25";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Eeyf3+zJYMRbfeTj+LdxMGEeouvvky6cAmADFqIoRNo=";
  };

  doCheck = true;

  cargoHash = "sha256-NJOVWIUObmjjamRDZsj7V6xKsfRfUeUqCiKBv/vNiEY=";

  nativeBuildInputs = [ installShellFiles ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = phraze; };
    };
  };

  postInstall = ''
    installManPage target/man/phraze.1

    installShellCompletion --cmd phraze \
      --bash target/completions/phraze.bash \
      --fish target/completions/phraze.fish \
      --zsh target/completions/_phraze
  '';

  meta = {
    description = "Generate random passphrases";
    homepage = "https://github.com/sts10/phraze";
    changelog = "https://github.com/sts10/phraze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      x123
      donovanglover
    ];
    mainProgram = "phraze";
  };
})
