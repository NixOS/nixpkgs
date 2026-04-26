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
  pkg-config,
  rustPlatform,
  stdenv,
  ...
}@args:

let
  version = "1.0.0";
  hash = "sha256-EF7eDNc4HFGZZw+f2RZ9LhPOcgKbuPq2Ckc0R+sC9pU=";
  cargoHash = "sha256-u4n4wGhb7BasEEM1C//As8K0eOp1GCVJWhCkqR9Z+II=";

  inherit (stdenv.hostPlatform)
    isLinux
    isWindows
    isx86_64
    isAarch64
    ;

  emulator = stdenv.hostPlatform.emulator buildPackages;
  exe = stdenv.hostPlatform.extensions.executable;

  # TODO: remove warning for the next release
  buildDeprecatedFeature = lib.warnIf (args ? withTcp) "withTcp is no longer needed, remove it" true;
  # notify feature is part of default cargo features
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

  pname = "comodoro";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "comodoro";
    rev = "v${version}";
  };

  nativeBuildInputs =
    [ ]
    ++ lib.optional hasNotifyFeature pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    # D-Bus is provided by vendors on Windows
    lib.optional (hasNotifyFeature && !isWindows) dbus';

  buildFeatures =
    [ ]
    ++ buildFeatures
    ++ lib.optional buildDeprecatedFeature ""
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
      ${emulator} "$out"/bin/comodoro${exe} manuals "$out"/share/man
      ${emulator} "$out"/bin/comodoro${exe} completions -d "$out"/share/completions bash elvish fish powershell zsh
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd comodoro \
        --bash "$out"/share/completions/comodoro.bash \
        --fish "$out"/share/completions/comodoro.fish \
        --zsh "$out"/share/completions/_comodoro
    '';

  meta = {
    description = "CLI to manage timers";
    mainProgram = "comodoro";
    homepage = "https://github.com/pimalaya/comodoro";
    changelog = "https://github.com/pimalaya/comodoro/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ soywod ];
  };
}
