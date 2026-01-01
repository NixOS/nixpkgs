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
<<<<<<< HEAD
  version = "1.24.2";
=======
  version = "1.24.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-QE0zsQa7JRSXbCBe9yGGGW2ZNo0kp+JD0/5jIyN0OIQ=";
=======
    hash = "sha256-yWG06l/Gu2/u4NNAyCYjxlmEKIsDAaxWGp6fmqXvNl8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  cargoHash = "sha256-CYRm8wvKK7HIPI1yxTWLV/wpK++mHVT9BvDVX96VFr0=";
=======
  cargoHash = "sha256-F7tzrMqF2xY8Ow+bAFbP0mQPomSe/oOHiQWHRHDmHio=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      Frostman
      da157
      sigmasquadron
    ];
    mainProgram = "starship";
  };
})
