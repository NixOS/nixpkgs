{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  cachix,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "omnix";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "juspay";
    repo = "omnix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxBZLeYoYIQlZLsWpJty95fUmEbgHPCwbn392b9n3NY=";
  };

  cargoHash = "sha256-qZv/4P9f87Glif2VsdrY23JGw6bSSQYdekF6erY5owk=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Note: The ENVs below will have to be kept in sync with <https://github.com/juspay/omnix/blob/main/nix/envs/default.nix>
  env = {
    OMNIX_SOURCE = finalAttrs.src;
    CACHIX_BIN = lib.getExe cachix;
    OM_INIT_REGISTRY = "path:${finalAttrs.src}/crates/omnix-init/registry";
    DEVOUR_FLAKE = fetchFromGitHub {
      owner = "srid";
      repo = "devour-flake";
      rev = "9fe4db872c107ea217c13b24527b68d9e4a4c01b";
      hash = "sha256-R7MHvTh5fskzxNLBe9bher+GQBZ8ZHjz75CPQG3fSRI=";
    };
    NIX_SYSTEMS =
      let
        x86_64-linux = fetchFromGitHub {
          owner = "nix-systems";
          repo = "x86_64-linux";
          rev = "2ecfcac5e15790ba6ce360ceccddb15ad16d08a8";
          hash = "sha256-Gtqg8b/v49BFDpDetjclCYXm8mAnTrUzR0JnE2nv5aw=";
        };
        aarch64-linux = fetchFromGitHub {
          owner = "nix-systems";
          repo = "aarch64-linux";
          rev = "aa1ce1b64c822dff925d63d3e771113f71ada1bb";
          hash = "sha256-1Zp7TRYLXj4P5FLhQ8jBChrgAmQxR3iTypmWf9EFTnc=";
        };
        x86_64-darwin = fetchFromGitHub {
          owner = "nix-systems";
          repo = "x86_64-darwin";
          rev = "db0463cce4cd60fb791f33a83d29a1ed53edab9b";
          hash = "sha256-+xT9B1ZbhMg/zpJqd00S06UCZb/A2URW9bqqrZ/JTOg=";
        };
        aarch64-darwin = fetchFromGitHub {
          owner = "nix-systems";
          repo = "aarch64-darwin";
          rev = "75e6c6912484d28ebba5769b794ffa4aff653ba2";
          hash = "sha256-PHVNQ7y0EQYzujQRYoRdb96K0m1KSeAjSrbz2b75S6Q=";
        };
      in
      builtins.toJSON {
        inherit
          x86_64-linux
          aarch64-linux
          x86_64-darwin
          aarch64-darwin
          ;
      };
    FALSE_FLAKE = fetchFromGitHub {
      owner = "boolean-option";
      repo = "false";
      rev = "d06b4794a134686c70a1325df88a6e6768c6b212";
      hash = "sha256-vLy8GQr0noEcoA+jX24FgUVBA/poV36zDWAUChN3hIY=";
    };
    TRUE_FLAKE = fetchFromGitHub {
      owner = "boolean-option";
      repo = "true";
      rev = "6ecb49143ca31b140a5273f1575746ba93c3f698";
      hash = "sha256-L9eyTL7njtPBUYmZRYFKCzQFDgua9U9oE7UwCzjZfl8=";
    };
    INSPECT_FLAKE = fetchFromGitHub {
      owner = "juspay";
      repo = "inspect";
      rev = "e82e65949d2ba5283865609b8728c50ebe7573e3";
      hash = "sha256-GTxRovvYWYn2/LDvjA73YttGuqvtKaOFZfOR9YxtST0=";
    };
    DEFAULT_FLAKE_SCHEMAS = "path:${finalAttrs.src}/nix/flake-schemas";
    FLAKE_METADATA = "path:${finalAttrs.src}/crates/nix_rs/src/flake/functions/metadata";
    FLAKE_ADDSTRINGCONTEXT = "path:${finalAttrs.src}/crates/nix_rs/src/flake/functions/addstringcontext";
  };

  # Requires networking and/or nix sandbox disabled
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd om \
      --bash <($out/bin/om completion bash) \
      --fish <($out/bin/om completion fish) \
      --zsh <($out/bin/om completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/om";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nix companion to improve developer experience";
    homepage = "https://omnix.page";
    changelog = "https://omnix.page/history.html#${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      shivaraj-bh
    ];
    license = lib.licenses.agpl3Only;
    mainProgram = "om";
  };
})
