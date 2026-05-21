{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  which,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dotter";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Dotfile manager and templater written in Rust";
    homepage = "https://github.com/SuperCuber/dotter";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "dotter";
  };
})
