{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage (self: {
  pname = "nix-secrets-unwrapped";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unnamed-systems";
    repo = "nix-secrets";
    tag = "v${self.version}";
    hash = "sha256-xwQP4fLPmXt67fMc5BaSKgrfsaSbv8tR+Z7kTSn6OqY=";
  };
  cargoBuildFlags = [
    "-p"
    "nix-secrets-cli"
  ];
  cargoTestFlags = [
    "-p"
    "nix-secrets-cli"
  ];

  cargoHash = "sha256-CUAdxsPoCOMDPkE9dIodSPVnKndY787P4f+BX7+XLZs=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    exe="$out/bin/${self.meta.mainProgram}"

    installShellCompletion --cmd ${self.meta.mainProgram} \
      --bash <(COMPLETE=bash $exe) \
      --fish <(COMPLETE=fish $exe) \
      --zsh <(COMPLETE=zsh $exe)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Postmodern secrets manager for NixOS";
    homepage = "https://github.com/unnamed-systems/nix-secrets";
    license = lib.licenses.eupl12;
    maintainers = [
      lib.maintainers.bananad3v
      lib.maintainers.yunfachi
    ];
    platforms = lib.platforms.all;
    mainProgram = "nix-secrets";
  };
})
