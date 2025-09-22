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
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Euhbuu1uiJ5HJNlPs9sUoGcc5QWqXqNmEH0jpfGLlc=";
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

  cargoHash = "sha256-cxDWaPlNK7POJ3GhA21NlJ6q62bqHdA/4sru5pLkvOA=";

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
      awwpotato
      sigmasquadron
    ];
    mainProgram = "starship";
  };
})
