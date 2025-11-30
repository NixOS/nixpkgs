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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starship";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yWG06l/Gu2/u4NNAyCYjxlmEKIsDAaxWGp6fmqXvNl8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    presetdir=$out/share/starship/presets/
    mkdir -p $presetdir
    cp docs/public/presets/toml/*.toml $presetdir
  ''
  + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd starship \
        --bash <(${emulator} $out/bin/starship completions bash) \
        --fish <(${emulator} $out/bin/starship completions fish) \
        --zsh <(${emulator} $out/bin/starship completions zsh)
    ''
  );

  cargoHash = "sha256-F7tzrMqF2xY8Ow+bAFbP0mQPomSe/oOHiQWHRHDmHio=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = {
    description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    downloadPage = "https://github.com/starship/starship";
    changelog = "https://github.com/starship/starship/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      danth
      Br1ght0ne
      Frostman
      da157
      sigmasquadron
    ];
    mainProgram = "starship";
  };
})
