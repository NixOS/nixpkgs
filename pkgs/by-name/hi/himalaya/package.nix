{
  apple-sdk,
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  dbus,
  fetchFromGitHub,
  gpgme,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  notmuch,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  version = "1.2.0";
  hash = "sha256-BBzfDeNu7s010ARCYuydCyR7QWrbeI3/B4CxA6d4olw=";
  cargoHash = "sha256-IkvRiU9NuD6n7aCF8J235u2LjjmLftnF1n874IWVcN0=";

  inherit (stdenv.hostPlatform)
    isLinux
    isWindows
    isAarch64
    ;

  emulator = stdenv.hostPlatform.emulator buildPackages;
  exe = stdenv.hostPlatform.extensions.executable;

  hasPgpGpgFeature = builtins.elem "pgp-gpg" buildFeatures;
  hasKeyringFeature = builtins.elem "keyring" buildFeatures;
  hasNotmuchFeature = builtins.elem "notmuch" buildFeatures;

  dbus' = dbus.overrideAttrs (old: {
    env = (old.env or { }) // {
      NIX_CFLAGS_COMPILE =
        (old.env.NIX_CFLAGS_COMPILE or "")
        # required for D-Bus on Linux AArch64
        + lib.optionalString (isLinux && isAarch64) " -mno-outline-atomics";
    };
  });

in
rustPlatform.buildRustPackage {
  inherit
    version
    cargoHash
    buildNoDefaultFeatures
    ;

  pname = "himalaya";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "himalaya";
    rev = "v${version}";
  };

  env = {
    # OpenSSL should not be provided by vendors, not even on Windows
    OPENSSL_NO_VENDOR = "1";
  };

  nativeBuildInputs =
    [ ]
    ++ lib.optional (hasPgpGpgFeature || hasKeyringFeature || hasNotmuchFeature) pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    [ ]
    ++ lib.optional hasPgpGpgFeature gpgme
    ++ lib.optional (hasKeyringFeature && !isWindows) dbus'
    ++ lib.optional hasNotmuchFeature notmuch;

  buildFeatures =
    buildFeatures
    # D-Bus is provided by vendors on Windows
    ++ lib.optional (hasKeyringFeature && isWindows) "vendored";

  # most of the tests are lib side
  doCheck = false;

  postInstall =
    lib.optionalString (lib.hasInfix "wine" emulator) ''
      export WINEPREFIX="''${WINEPREFIX:-$(mktemp -d)}"
      mkdir -p $WINEPREFIX
    ''
    + ''
      mkdir -p $out/share/{applications,completions,man}
      cp assets/himalaya.desktop "$out"/share/applications/
      ${emulator} "$out"/bin/himalaya${exe} man "$out"/share/man
      ${emulator} "$out"/bin/himalaya${exe} completion bash > "$out"/share/completions/himalaya.bash
      ${emulator} "$out"/bin/himalaya${exe} completion elvish > "$out"/share/completions/himalaya.elvish
      ${emulator} "$out"/bin/himalaya${exe} completion fish > "$out"/share/completions/himalaya.fish
      ${emulator} "$out"/bin/himalaya${exe} completion powershell > "$out"/share/completions/himalaya.powershell
      ${emulator} "$out"/bin/himalaya${exe} completion zsh > "$out"/share/completions/himalaya.zsh
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
