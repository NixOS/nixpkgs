{
  bash,
  dbus,
  fetchFromGitHub,
  just,
  lib,
  rustPlatform,
  stdenv,
  xdg-desktop-portal-cosmic,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-MXYqo/DsopBRQgvG5DYwlYSYiVUZ2r43K0bTQBTGMl8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cArfyknKe8vtZcGxdOEqjGYQUDMW1ObprqnGjKoyU68=";

  postPatch = ''
    substituteInPlace Justfile \
      --replace-fail '{{cargo-target-dir}}/release/cosmic-session' 'target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-session'
    substituteInPlace data/start-cosmic \
      --replace-fail /usr/bin/cosmic-session "''${!outputBin}/bin/cosmic-session" \
      --replace-fail /usr/bin/dbus-run-session '${lib.getExe' dbus "dbus-run-session"}' \
      --replace-fail 'systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP' '${lib.getExe' dbus "dbus-update-activation-environment"} --systemd PATH XDG_SESSION_CLASS XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DCONF_PROFILE XDG_DESKTOP_PORTAL_DIR DISPLAY WAYLAND_DISPLAY XMODIFIERS XCURSOR_SIZE XCURSOR_THEME GDK_PIXBUF_MODULE_FILE GIO_EXTRA_MODULES GTK_IM_MODULE QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_IM_MODULE NIXOS_OZONE_WL &>/dev/null'
    substituteInPlace data/cosmic.desktop \
      --replace-fail /usr/bin/start-cosmic "''${!outputBin}/bin/start-cosmic"
  '';

  nativeBuildInputs = [ just ];
  buildInputs = [ bash ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")

    # TODO: This is somewhere in master, after the 4th alpha.
    #       Uncomment with the version bump.
    #"--set"
    #"cosmic_dconf_profile"
    #"cosmic"
  ];

  env.XDP_COSMIC = lib.getExe xdg-desktop-portal-cosmic;

  postInstall = ''
    mkdir -p $out/etc
    cp -r data/dconf $out/etc/
  '';

  passthru.providedSessions = [ "cosmic" ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-session";

    maintainers = with maintainers; [
      a-kenji
      nyabinary
      thefossguy
    ];
  };
}
