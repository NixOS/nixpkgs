{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  libiconv,
  cachix,
  nix,
}:
rustPlatform.buildRustPackage rec {
  pname = "omnix";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "juspay";
    repo = "omnix";
    rev = "rust-stable";
    # tag = version;
    hash = "sha256-oewXpsBfy4rHIGjMzNMedYCZOrv7OzkhRwxuzYcOv0s=";
    # hash = "sha256-8fNqg7TNVKjv3kusLJPb4X6A9uCztdntQpo6I/cOV7g=";
  };

  useFetchCargoVendor = true;
  cargoHash =  "sha256-TgLiRssNwuvuGmuuBEoqwKXI/s6cECNSKvsjUTmpDMI=";

  nativeBuildInputs = [
    libiconv
    pkg-config
    installShellFiles
    nix
  ];

  buildInputs = [
    openssl
  ];

  OMNIX_SOURCE = src;
  CACHIX_BIN = lib.getExe cachix;
  OM_INIT_REGISTRY = lib.cleanSourceWith {
    name = "om-init-registry";
    src = src + /crates/omnix-init/registry;
  };
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
    inherit x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin;
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
    rev = "inventory-for-systems";
    hash = "sha256-GTxRovvYWYn2/LDvjA73YttGuqvtKaOFZfOR9YxtST0=";
  };
  DEFAULT_FLAKE_SCHEMAS = lib.cleanSourceWith {
    name = "flake-schemas";
    src = src + /nix/flake-schemas;
  };
  FLAKE_METADATA = lib.cleanSourceWith {
    name = "nix-rs-flake-metadata";
    src = src + /crates/nix_rs/src/flake/functions/metadata;
  };
  FLAKE_ADDSTRINGCONTEXT = lib.cleanSourceWith {
    name = "nix-rs-flake-addstringcontext";
    src = src + /crates/nix_rs/src/flake/functions/addstringcontext;
  };

  checkFlags = [
    # requires networking
    "--skip=config::core::tests::test_config_loading"
    "--skip=command::ci::build_flake_output"
    "--skip=command::ci::test_haskell_multi_nix"
    "--skip=command::ci::test_haskell_multi_nix_all_dependencies"
    "--skip=command::ci::test_services_flake"
    "--skip=command::show::om_show_nixos_configurations"
    "--skip=command::show::om_show_remote"
    "--skip=config::test_get_omconfig_from_remote_flake_with_attr"

    # required health checks, like "Flakes Enabled" and "Max Jobs" fails in sandbox
    "--skip=command::health::om_health"

    # error: creating directory '/nix/var/nix/profiles': Permission denied
    # TODO: elaborate on the error
    "--skip=command::init::om_init"

    # error: experimental Nix feature \'flakes\' is disabled; add \'--extra-experimental-features flakes\' to enable it.
    # While running `nix eval` to evaluate flake-schemas
    "--skip=command::show::om_show_local"
  ];

  postInstall = ''
    installShellCompletion --cmd om \
      --bash <($out/bin/om completion bash) \
      --fish <($out/bin/om completion fish) \
      --zsh <($out/bin/om completion zsh)
  '';

  meta = with lib; {
    description = "A Nix companion to improve developer experience";
    homepage = "https://omnix.page";
    maintainers = with maintainers; [
      shivaraj-bh
    ];
    license = licenses.agpl3Only;
    mainProgram = "om";
  };
}
