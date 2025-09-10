{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixVersions,
  nixosTests,
  boost,
  pkg-config,
  stdenv,
  installShellFiles,
  nix-update-script,
  crates ? [ "attic-client" ],
}:

let
  # Only the attic-client crate builds against the Nix C++ libs
  # This derivation is also used to build the server
  needNixInclude = lib.elem "attic-client" crates;
  nix = nixVersions.nix_2_28;
in

rustPlatform.buildRustPackage {
  pname = "attic";
  version = "0-unstable-2025-08-28";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "2524dd1c007bc7a0a9e9c863a1b02de8d54b319b";
    hash = "sha256-S4SJDmVTtbcXaJkYrMFkcA5SDrpfRHlBbzwp6IRRPAw=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional needNixInclude nix ++ [ boost ];

  cargoBuildFlags = lib.concatMapStrings (c: "-p ${c} ") crates;
  cargoHash = "sha256-NdzwYnD0yMEI2RZwwXl/evYx9zdBVMOUee+V7uq1cf0=";

  env = {
    ATTIC_DISTRIBUTOR = "nixpkgs";
  }
  // lib.optionalAttrs needNixInclude { NIX_INCLUDE_PATH = "${lib.getDev nix}/include"; };

  # Attic interacts with Nix directly and its tests require trusted-user access
  # to nix-daemon to import NARs, which is not possible in the build sandbox.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    if [[ -f $out/bin/attic ]]; then
      installShellCompletion --cmd attic \
        --bash <($out/bin/attic gen-completions bash) \
        --zsh <($out/bin/attic gen-completions zsh) \
        --fish <($out/bin/attic gen-completions fish)
    fi
  '';

  passthru = {
    tests = { inherit (nixosTests) atticd; };

    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Multi-tenant Nix Binary Cache";
    homepage = "https://github.com/zhaofengli/attic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      zhaofengli
      aciceri
      defelo
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "attic";
  };
}
