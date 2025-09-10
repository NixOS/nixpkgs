{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  which,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
    hash = "sha256-cxabaCxbwP2YbnG2XfmVJWFTw9LGO0D1dlLy6fuux+M=";
  };

  cargoHash = "sha256-KLU+4CYqTKEH8wuvinVS0Zs+nFgOer2ho8LXnLDNVKY=";

  nativeCheckInputs = [
    which
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dotter \
      --bash <($out/bin/dotter gen-completions --shell bash) \
      --fish <($out/bin/dotter gen-completions --shell fish) \
      --zsh <($out/bin/dotter gen-completions --shell zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Dotfile manager and templater written in Rust";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
