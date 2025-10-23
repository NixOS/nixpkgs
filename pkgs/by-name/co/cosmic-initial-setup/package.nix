{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  killall,
  libcosmicAppHook,
  libinput,
  openssl,
  udev,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-initial-setup";
  version = "1.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-initial-setup";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-sgtZioUvBDSqlBVWbqGc2iVpZKF0fn/Mr1qo1qlzdlA=";
  };

  cargoHash = "sha256-orwK9gcFXK4/+sfwRubcz0PP6YAFqsENRHnlSLttLxM=";

  buildFeatures = [ "nixos" ];

  # cargo-auditable fails during the build when compiling the `crabtime::function`
  # procedural macro. It panics because the `--out-dir` flag is not passed to
  # the rustc wrapper.
  #
  # Reported this issue upstream in:
  # https://github.com/rust-secure-code/cargo-auditable/issues/225
  auditable = false;

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    killall
    libinput
    openssl
    udev
  ];

  postPatch = ''
    # Installs in $out/etc/xdg/autostart instead of /etc/xdg/autostart
    substituteInPlace justfile \
      --replace-fail \
      "autostart-dst := rootdir / 'etc' / 'xdg' / 'autostart' / desktop-entry" \
      "autostart-dst := prefix / 'etc' / 'xdg' / 'autostart' / desktop-entry"
  '';

  preFixup = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ killall ]})
  '';

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  env.DISABLE_IF_EXISTS = "/iso/nix-store.squashfs";

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    description = "COSMIC Initial Setup";
    homepage = "https://github.com/pop-os/cosmic-initial-setup";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-initial-setup";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cosmic ];
  };
})
