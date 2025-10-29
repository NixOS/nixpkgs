{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  buildPackages,
  pkg-config,
  apple-sdk,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  notmuch,
  gpgme,
  buildNoDefaultFeatures ? false,
  buildFeatures ? [ ],
  withNoDefaultFeatures ? buildNoDefaultFeatures,
  withFeatures ? buildFeatures,
}@args:

let
  version = "1.1.0";
  hash = "sha256-gdrhzyhxRHZkALB3SG/aWOdA5iMYkel3Cjk5VBy3E4M=";
  cargoHash = "sha256-ulqMjpW3UI509vs3jVHXAEQUhxU/f/hN8XiIo8UBRq8=";

  noDefaultFeatures =
    lib.warnIf (args ? buildNoDefaultFeatures)
      "buildNoDefaultFeatures is deprecated in favour of withNoDefaultFeatures and will be removed in the next release"
      withNoDefaultFeatures;

  features =
    lib.warnIf (args ? buildFeatures)
      "buildFeatures is deprecated in favour of withFeatures and will be removed in the next release"
      withFeatures;
in

rustPlatform.buildRustPackage {
  inherit version cargoHash;

  pname = "himalaya";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "himalaya";
    rev = "v${version}";
  };

  buildNoDefaultFeatures = noDefaultFeatures;
  buildFeatures = features;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    [ ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk
    ++ lib.optional (builtins.elem "notmuch" withFeatures) notmuch
    ++ lib.optional (builtins.elem "pgp-gpg" withFeatures) gpgme;

  # most of the tests are lib side
  doCheck = false;

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir -p $out/share/{applications,completions,man}
      cp assets/himalaya.desktop "$out"/share/applications/
      ${emulator} "$out"/bin/himalaya man "$out"/share/man
      ${emulator} "$out"/bin/himalaya completion bash > "$out"/share/completions/himalaya.bash
      ${emulator} "$out"/bin/himalaya completion elvish > "$out"/share/completions/himalaya.elvish
      ${emulator} "$out"/bin/himalaya completion fish > "$out"/share/completions/himalaya.fish
      ${emulator} "$out"/bin/himalaya completion powershell > "$out"/share/completions/himalaya.powershell
      ${emulator} "$out"/bin/himalaya completion zsh > "$out"/share/completions/himalaya.zsh
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion "$out"/share/completions/himalaya.{bash,fish,zsh}
    '';

  meta = {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "https://github.com/pimalaya/himalaya/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soywod
      yanganto
    ];
  };
}
