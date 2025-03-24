{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hanko";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "SRv6d";
    repo = "hanko";
    tag = "v${version}";
    hash = "sha256-gytnUta/sNa8vJMvVS/DMwRc4R/8rmOnEfBKEjRpfGs=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-UHA7NI/LtyY8ucj+PavKdqym8o5HtGUD7+60UYnGohM=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage assets/manpages/*.1

    installShellCompletion assets/completions/hanko.bash
    installShellCompletion assets/completions/_hanko
    installShellCompletion assets/completions/hanko.fish
  '';

  meta = {
    description = "Keeps your Git allowed signers file up to date";
    homepage = "https://github.com/SRv6d/hanko";
    changelog = "https://github.com/SRv6d/hanko/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srv6d ];
    mainProgram = "hanko";
  };
}
