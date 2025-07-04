{
  lib,
  fetchFromGitHub,
  testers,
  nix-update-script,
  phraze,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "phraze";
  version = "0.3.23";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${version}";
    hash = "sha256-CQhzH6x8Fxx0ynHbLh8FTY7urbiXHrvTbMh+/TAwS2A=";
  };

  doCheck = true;

  useFetchCargoVendor = true;
  cargoHash = "sha256-d4qj4rvH5CyHTH3RWDV6ADSGK/kz6yQLp3JjQdb6Wyo=";

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
    changelog = "https://github.com/sts10/phraze/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      x123
      donovanglover
    ];
    mainProgram = "phraze";
  };
}
