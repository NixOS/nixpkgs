{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  just,
  libcosmicAppHook,
  libinput,
  openssl,
  udev,
  nixosTests,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-initial-setup";
  version = "1.0.0-beta.1.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-initial-setup";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-kjJqGNcIlnzEsfA4eQ9D23ZGgRcmWQyWheAlwpjfALA=";
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
    libinput
    openssl
    udev
  ];

  # These are not needed for NixOS
  patches = [
    ./disable-language-page.patch
    ./disable-timezone-page.patch
    # TODO: Remove in next update
    (fetchpatch2 {
      name = "fix-layout-and-themes-page.patch";
      url = "https://patch-diff.githubusercontent.com/raw/pop-os/cosmic-initial-setup/pull/53.diff?full_index=1";
      hash = "sha256-081qyQnPhh+FRPU/JKJVCK+l3SKjHAIV5b6/7WN6lb8=";
    })
  ];

  postPatch = ''
    # Installs in $out/etc/xdg/autostart instead of /etc/xdg/autostart
    substituteInPlace justfile \
      --replace-fail \
      "autostart-dst := rootdir / 'etc' / 'xdg' / 'autostart' / desktop-entry" \
      "autostart-dst := prefix / 'etc' / 'xdg' / 'autostart' / desktop-entry"
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
