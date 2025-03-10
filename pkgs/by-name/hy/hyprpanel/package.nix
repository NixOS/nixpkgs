{
  lib,
  config,
  ags,
  astal,
  bluez,
  bluez-tools,
  brightnessctl,
  btop,
  dart-sass,
  fetchFromGitHub,
  fetchpatch2,
  glib,
  gnome-bluetooth,
  gpu-screen-recorder,
  gpustat,
  grimblast,
  gvfs,
  hyprpicker,
  libgtop,
  libnotify,
  matugen,
  networkmanager,
  python3,
  pywal,
  stdenv,
  swww,
  upower,
  wireplumber,
  wl-clipboard,
  writeShellScript,

  enableCuda ? config.cudaSupport,
}:
ags.bundle {
  pname = "hyprpanel";
  version = "unstable-2025-02-17";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Jas-SinghFSU";
    repo = "HyprPanel";
    rev = "9b342341fe17e4fb2c4cad9e3379a814a6a73097";
    hash = "sha256-OQS2yhBYJZPvxkPGEx9FqT+voXTDm0UJDknCBBWgroo=";
  };

  patches = [
    # please merge https://github.com/NixOS/nixpkgs/pull/374302
    ./remove-tray.patch
  ];

  # keep in sync with https://github.com/Jas-SinghFSU/HyprPanel/blob/master/flake.nix#L28
  dependencies = [
    astal.apps
    astal.battery
    astal.bluetooth
    astal.cava
    astal.hyprland
    astal.mpris
    astal.network
    astal.notifd
    astal.powerprofiles
    # https://github.com/NixOS/nixpkgs/pull/374302
    # astal.tray
    astal.wireplumber

    bluez
    bluez-tools
    brightnessctl
    btop
    dart-sass
    glib
    gnome-bluetooth
    grimblast
    gvfs
    hyprpicker
    libgtop
    libnotify
    matugen
    networkmanager
    pywal
    swww
    upower
    wireplumber
    wl-clipboard
    (python3.withPackages (
      ps:
      with ps;
      [
        dbus-python
        pygobject3
      ]
      ++ lib.optional enableCuda gpustat
    ))
  ] ++ (lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [ gpu-screen-recorder ]);

  # NOTE: no update script as dependencies must be kept in sync with upstream
  # and it is problematic to do it in an update script. I don't have push
  # access to r-ryantm's repo, so I will just do updates manually

  postFixup =
    let
      script = writeShellScript "hyprpanel" ''
        if [ "$#" -eq 0 ]; then
          exec @out@/bin/.hyprpanel
        else
          exec ${astal.io}/bin/astal -i hyprpanel "$*"
        fi
      '';
    in
    # bash
    ''
      mv "$out/bin/hyprpanel" "$out/bin/.hyprpanel"
      cp '${script}' "$out/bin/hyprpanel"
      substituteInPlace "$out/bin/hyprpanel" \
        --replace-fail '@out@' "$out"
    '';

  meta = {
    description = "Bar/Panel for Hyprland with extensive customizability";
    homepage = "https://github.com/Jas-SinghFSU/HyprPanel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "hyprpanel";
    platforms = lib.platforms.linux;
  };
}
