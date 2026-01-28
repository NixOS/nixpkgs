{
  lib,
  fetchFromGitHub,
  bash,
  rustPlatform,
  just,
  dbus,
  stdenv,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-session";
  version = "1.0.3";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-JlRGK3uac94r81MBaOZZ4hRcKD4fh/vgJBxic0BSWnY=";
  };

  cargoHash = "sha256-wFh9AYQRZB9qK0vCrhW9Zk61Yg+VY3VPAqJRD47NbK4=";

  postPatch = ''
    substituteInPlace data/start-cosmic \
      --replace-fail '/usr/bin/cosmic-session' "${placeholder "out"}/bin/cosmic-session" \
      --replace-fail '/usr/bin/dbus-run-session' "${lib.getBin dbus}/bin/dbus-run-session" \
      --replace-fail 'systemctl --user import-environment ' 'dbus-update-activation-environment --verbose --all --systemd || systemctl --user import-environment #'
    substituteInPlace data/cosmic.desktop \
      --replace-fail '/usr/bin/start-cosmic' "${placeholder "out"}/bin/start-cosmic"
  '';

  buildInputs = [ bash ];
  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cosmic_dconf_profile"
    "${placeholder "out"}/etc/dconf/profile/cosmic"
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  env.ORCA = "orca"; # get orca from $PATH

  passthru = {
    providedSessions = [ "cosmic" ];
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
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-session";
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
