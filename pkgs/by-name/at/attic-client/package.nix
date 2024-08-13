{ lib
, rustPlatform
, fetchFromGitHub
, nix
, boost
, pkg-config
, stdenv
, installShellFiles
, darwin
, crates ? [ "attic-client" ]
}:
rustPlatform.buildRustPackage {
  pname = "attic";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "e127acbf9a71ebc0c26bc8e28346822e0a6e16ba";
    hash = "sha256-GJIz4M5HDB948Ex/8cPvbkrNzl/eKUE7/c21JBu4lb8=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    nix
    boost
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    SystemConfiguration
  ]);

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-base32-0.1.2-alpha.0" = "sha256-wtPWGOamy3+ViEzCxMSwBcoR4HMMD0t8eyLwXfCDFdo=";
    };
  };
  cargoBuildFlags = lib.concatMapStrings (c: "-p ${c} ") crates;

  ATTIC_DISTRIBUTOR = "attic";
  NIX_INCLUDE_PATH = "${lib.getDev nix}/include";

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

  meta = with lib; {
    description = "Multi-tenant Nix Binary Cache";
    homepage = "https://github.com/zhaofengli/attic";
    license = licenses.asl20;
    maintainers = with maintainers; [ zhaofengli aciceri ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "attic";
  };
}
