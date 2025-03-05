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
    rev = "common-env";
    # tag = version;
    hash = "sha256-1Q6q20WI6Nl/xmUtzv+lUkW9Xv5bGVxJ8WSlMKaFiIA=";
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

  env = import "${src}/nix/envs" { inherit src cachix fetchFromGitHub lib; };

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

    # FIXME
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
