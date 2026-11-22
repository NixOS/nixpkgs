{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  writableTmpDirAsHomeHook,
  gitMinimal,
  nixosTests,
  buildPackages,
  tzdata,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starship";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aq79POUoeKnG/gNG3rpmayhER61kiUCE8gsHGbvT66w=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    writableTmpDirAsHomeHook
  ];

  env.TZDIR = "${tzdata}/share/zoneinfo";

  postInstall = ''
    integrationdir=$out/share/starship/shell-integration
    mkdir -p "$integrationdir"
    for shell in bash zsh fish nu; do
      install -m644 "src/init/starship.$shell" "$integrationdir/starship.$shell.in"
    done

    presetdir=$out/share/starship/presets/
    mkdir -p $presetdir
    cp docs/public/presets/toml/*.toml $presetdir
    install -Dm644 .github/config-schema.json $out/share/starship/config-schema.json
  ''
  + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd starship \
        --bash <(${emulator} $out/bin/starship completions bash) \
        --fish <(${emulator} $out/bin/starship completions fish) \
        --nushell <(${emulator} $out/bin/starship completions nushell) \
        --zsh <(${emulator} $out/bin/starship completions zsh)
    ''
  );

  cargoHash = "sha256-m5UbV/9SpTpBga+PDaqwWi9k9W5BUZ+rz+t5dliJyjM=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  passthru = {
    shellIntegration = "${finalAttrs.finalPackage}/share/starship/shell-integration";
    jsonschema = {
      config = "${finalAttrs.finalPackage}/share/starship/config-schema.json";
    };
    tests = {
      inherit (nixosTests) starship;
    };
  };

  meta = {
    description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    downloadPage = "https://github.com/starship/starship";
    changelog = "https://github.com/starship/starship/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      Frostman
      da157
      sigmasquadron
    ];
    mainProgram = "starship";
  };
})
