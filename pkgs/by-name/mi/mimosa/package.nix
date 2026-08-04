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
}:

let
  version = "1.0.0";
  hash = "sha256-8Re4Jy80K3g69yrx+FcWUrzf6lhPFOdVPo0x5/IXHDo=";
  cargoHash = "sha256-UXPK5fBah0DkwX3UnGUYbTpoArvDGD7anBcNK89whOk=";

  inherit (stdenv.hostPlatform)
    isLinux
    isWindows
    isAarch64
    ;

  emulator = stdenv.hostPlatform.emulator buildPackages;
  exe = stdenv.hostPlatform.extensions.executable;

  # dbus-secret-service feature is part of default cargo features
  hasDbusSecretService = !buildNoDefaultFeatures || builtins.elem "dbus-secret-service" buildFeatures;

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

  pname = "mimosa";

  src = fetchFromGitHub {
    inherit hash;
    owner = "pimalaya";
    repo = "mimosa";
    rev = "v${version}";
  };

  nativeBuildInputs =
    [ ]
    ++ lib.optional hasDbusSecretService pkg-config
    ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs =
    [ ]
    # D-Bus is provided by vendors on Windows
    ++ lib.optional (hasDbusSecretService && !isWindows) dbus';

  buildFeatures =
    buildFeatures
    # D-Bus is provided by vendors on Windows
    ++ lib.optional (hasDbusSecretService && isWindows) "vendored";

  doCheck = false;

  postInstall =
    lib.optionalString (lib.hasInfix "wine" emulator) ''
      export WINEPREFIX="''${WINEPREFIX:-$(mktemp -d)}"
      mkdir -p $WINEPREFIX
    ''
    + ''
      mkdir -p $out/share/{completions,man}
      ${emulator} "$out"/bin/mimosa${exe} manuals "$out"/share/man
      ${emulator} "$out"/bin/mimosa${exe} completions -d "$out"/share/completions bash elvish fish powershell zsh
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd mimosa \
        --bash "$out"/share/completions/mimosa.bash \
        --fish "$out"/share/completions/mimosa.fish \
        --zsh "$out"/share/completions/_mimosa
    '';

  meta = {
    description = "CLI to manage passwords";
    mainProgram = "mimosa";
    homepage = "https://github.com/pimalaya/mimosa";
    changelog = "https://github.com/pimalaya/mimosa/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ soywod ];
  };
}
