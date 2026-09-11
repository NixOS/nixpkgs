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
  version = "0.3.28";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lj3zKgGWJzIqTG9Kw+p3PNnVmEmZ8f8GPh4HvorlPsI=";
  };

  doCheck = true;

  cargoHash = "sha256-xKqEZdZqu76rE1/rdMW3nTzZEXdCr2qMTp7SY1dbQTQ=";

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
