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
  nix = nixVersions.nix_2_34;
in

rustPlatform.buildRustPackage {
  pname = "attic";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "6b22d76ca351c5a07a5e5a60b95bc23320f7e791";
    hash = "sha256-sboz+gG8z0KX+q0kkvLloNcogXYLwiY5iw2xwN36rFo=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional needNixInclude nix ++ [ boost ];

  cargoBuildFlags = lib.concatMapStrings (c: "-p ${c} ") crates;
  cargoHash = "sha256-LqE4jOIasxIG4DAhgZJMlTSyt/a900QR06wBFtRNRO8=";

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
