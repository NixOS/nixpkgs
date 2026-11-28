{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  stdenv,
  curl,
  sqlite,
  openssl,
  buildPackages,
  installShellFiles,
}:

let
  canRunCmd = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gix = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/gix";
  ein = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/ein";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitoxide";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "GitoxideLabs";
    repo = "gitoxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5r3hDf/MEN3DCmIRpudi7N6SluJ7CRZhuT9luqeMnQI=";
  };

  cargoHash = "sha256-RGpIsz7/1/VQ6Octf09pvEmryVRu8VMDsKAcaNiWebI=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    curl
    sqlite
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  preFixup = lib.optionalString canRunCmd ''
    installShellCompletion --cmd gix \
      --bash <(${gix} completions --shell bash) \
      --fish <(${gix} completions --shell fish) \
      --zsh <(${gix} completions --shell zsh)

    installShellCompletion --cmd ein \
      --bash <(${ein} completions --shell bash) \
      --fish <(${ein} completions --shell fish) \
      --zsh <(${ein} completions --shell zsh)
  '';

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Command-line application for interacting with git repositories";
    homepage = "https://github.com/GitoxideLabs/gitoxide";
    changelog = "https://github.com/GitoxideLabs/gitoxide/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [ hythera ];
    # NB: `ein` is also provided by this package, but `nix run
    # nixpkgs#gitoxide` doesn't work at all without this set.
    mainProgram = "gix";
  };
})
