{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  boost,
  pkg-config,
  stdenv,
  installShellFiles,
  darwin,
  crates ? [ "attic-client" ],
}:
rustPlatform.buildRustPackage {
  pname = "attic";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "6eabc3f02fae3683bffab483e614bebfcd476b21";
    hash = "sha256-wSZjK+rOXn+UQiP1NbdNn5/UW6UcBxjvlqr2wh++MbM=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      nix
      boost
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        SystemConfiguration
      ]
    );

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-base32-0.1.2-alpha.0" = "sha256-wtPWGOamy3+ViEzCxMSwBcoR4HMMD0t8eyLwXfCDFdo=";
    };
  };
  cargoBuildFlags = lib.concatMapStrings (c: "-p ${c} ") crates;

  ATTIC_DISTRIBUTOR = "attic";

  # Attic interacts with Nix directly and its tests require trusted-user access
  # to nix-daemon to import NARs, which is not possible in the build sandbox.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
    maintainers = with maintainers; [
      zhaofengli
      aciceri
    ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "attic";
  };
}
