{
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  dbus,
  fetchFromGitHub,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  version = "1.1.0";
  hash = "sha256-DcSYPz3pgNaVZMvt9iqVsD8Dzrs1azk+ZYldQNYAMcU=";
  cargoHash = "sha256-klIb4CkIs8hhjz5fFaUlyMR53/wAa2oCtk9Jp0fYVM0=";

  inherit (stdenv.hostPlatform)
    isLinux
    isWindows
    isAarch64
    ;

  emulator = stdenv.hostPlatform.emulator buildPackages;
  exe = stdenv.hostPlatform.extensions.executable;

  hasNativeTlsFeature = builtins.elem "native-tls" buildFeatures;
  hasNotifyFeature = !buildNoDefaultFeatures || builtins.elem "notify" buildFeatures;

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
  inherit cargoHash version buildNoDefaultFeatures;

  pname = "ortie";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "ortie";
    rev = "v${version}";
  };

  env = {
    # OpenSSL should not be provided by vendors, not even on Windows
    OPENSSL_NO_VENDOR = "1";
  };

  nativeBuildInputs =
    [ ]
    ++ lib.optional (hasNativeTlsFeature || hasNotifyFeature) pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    [ ]
    ++ lib.optional hasNativeTlsFeature openssl
    # D-Bus is provided by vendors on Windows
    ++ lib.optional (hasNotifyFeature && !isWindows) dbus';

  buildFeatures =
    buildFeatures
    # D-Bus is provided by vendors on Windows
    ++ lib.optional (hasNotifyFeature && isWindows) "vendored";

  doCheck = false;

  postInstall =
    lib.optionalString (lib.hasInfix "wine" emulator) ''
      export WINEPREFIX="''${WINEPREFIX:-$(mktemp -d)}"
      mkdir -p $WINEPREFIX
    ''
    + ''
      mkdir -p $out/share/{completions,man}
      ${emulator} "$out"/bin/ortie${exe} manuals "$out"/share/man
      ${emulator} "$out"/bin/ortie${exe} completions -d "$out"/share/completions bash elvish fish powershell zsh
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd ortie \
        --bash "$out"/share/completions/ortie.bash \
        --fish "$out"/share/completions/ortie.fish \
        --zsh "$out"/share/completions/_ortie
    '';

  meta = {
    description = "CLI to manage OAuth tokens";
    mainProgram = "ortie";
    homepage = "https://github.com/pimalaya/ortie";
    changelog = "https://github.com/pimalaya/ortie/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ soywod ];
  };
}
