{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libevdev,
  hidapi,
  systemd,
  dbus,
  lua54Packages,
  gtksourceview4,
  gtk3,
  protobuf,
  xorg,
  libpulseaudio,
  pkg-config,
  libusb1,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "eruption";
  version = "0.3.5-unstable-2023-12-19";

  src = fetchFromGitHub {
    owner = "eruption-project";
    repo = "eruption";
    rev = "4884ace33ed560ba058e5fa2824b4f3852f0ca90";
    hash = "sha256-Ty5TWW+o2hQiAko20sqZEYKS2LOqkFmyOxqWVbRP7Kc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qvjb1Tao5reX8c7fzCUjGj4MRFC8SY2eCDHz2hQIFNE=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [
    libevdev
    hidapi
    systemd
    dbus
    lua54Packages.lua
    lua54Packages.luasocket
    gtksourceview4
    gtk3
    xorg.libX11
    xorg.libXrandr
    libpulseaudio
    libusb1
    libxkbcommon
  ];

  # This patch updates the version of the "time" crate to 0.3.37
  # to fix an issue that arises if the code compiled with
  # a rust version 1.80.0 or newer
  cargoPatches = [ ./fix-time.patch ];

  postInstall = ''
    mkdir -p "$out/etc/eruption"
    mkdir -p "$out/etc/profile.d"
    mkdir -p "$out/usr/share/doc/eruption"
    mkdir -p "$out/usr/share/eruption/scripts/lib/macros"
    mkdir -p "$out/usr/share/eruption/scripts/lib/keymaps"
    mkdir -p "$out/usr/share/eruption/scripts/lib/themes"
    mkdir -p "$out/usr/share/eruption/scripts/lib/hwdevices/keyboards"
    mkdir -p "$out/usr/share/eruption/scripts/lib/hwdevices/mice"
    mkdir -p "$out/usr/share/eruption/scripts/examples"
    mkdir -p "$out/share/applications"
    mkdir -p "$out/usr/share/icons/hicolor/64x64/apps"
    mkdir -p "$out/usr/share/eruption-gui-gtk3/schemas"
    mkdir -p "$out/var/lib/eruption/profiles"
    mkdir -p "$out/lib/systemd/system"
    mkdir -p "$out/lib/systemd/system-preset"
    mkdir -p "$out/lib/systemd/user"
    mkdir -p "$out/lib/systemd/user-preset"
    mkdir -p "$out/lib/systemd/system-sleep"
    mkdir -p "$out/lib/udev/rules.d/"
    mkdir -p "$out/share/dbus-1/system.d"
    mkdir -p "$out/share/dbus-1/session.d"
    mkdir -p "$out/share/man/man8"
    mkdir -p "$out/share/man/man5"
    mkdir -p "$out/share/man/man1"
    mkdir -p "$out/share/bash-completion/completions"
    mkdir -p "$out/share/fish/completions"
    mkdir -p "$out/share/zsh/site-functions"
    mkdir -p "$out/usr/share/eruption/i18n"
    mkdir -p "$out/usr/share/eruption/sfx"
    mkdir -p "$out/lib/udev/rules.d"
    mkdir -p "$out/share/polkit-1/actions"

    cp "support/assets/eruption-gui-gtk3/eruption-gui-gtk3.desktop" "$out/share/applications/"
    cp "support/assets/eruption-gui-gtk3/eruption-gui.png" "$out/usr/share/icons/hicolor/64x64/apps/"
    cp "eruption-gui-gtk3/schemas/gschemas.compiled" "$out/usr/share/eruption-gui-gtk3/schemas/"

    cp "support/config/eruption.conf" "$out/etc/eruption/"
    cp "support/config/fx-proxy.conf" "$out/etc/eruption/"
    cp "support/config/audio-proxy.conf" "$out/etc/eruption/"
    cp "support/config/process-monitor.conf" "$out/etc/eruption/"
    cp "support/profile.d/eruption.sh" "$out/etc/profile.d/eruption.sh"

    cp "support/man/eruption.8" "$out/share/man/man8/"
    cp "support/man/eruption-cmd.8" "$out/share/man/man8/"
    cp "support/man/eruption.conf.5" "$out/share/man/man5/"
    cp "support/man/process-monitor.conf.5" "$out/share/man/man5/"
    cp "support/man/eruptionctl.1" "$out/share/man/man1/"
    cp "support/man/eruption-hwutil.8" "$out/share/man/man8/"
    cp "support/man/eruption-macro.1" "$out/share/man/man1/"
    cp "support/man/eruption-keymap.1" "$out/share/man/man1/"
    cp "support/man/eruption-netfx.1" "$out/share/man/man1/"
    cp "support/man/eruption-fx-proxy.1" "$out/share/man/man1/"
    cp "support/man/eruption-audio-proxy.1" "$out/share/man/man1/"
    cp "support/man/eruption-process-monitor.1" "$out/share/man/man1/"

    cp "support/shell/completions/en_US/eruption-cmd.bash-completion" "$out/share/bash-completion/completions/eruption-cmd"
    cp "support/shell/completions/en_US/eruption-hwutil.bash-completion" "$out/share/bash-completion/completions/eruption-hwutil"
    cp "support/shell/completions/en_US/eruption-debug-tool.bash-completion" "$out/share/bash-completion/completions/eruption-debug-tool"
    cp "support/shell/completions/en_US/eruption-macro.bash-completion" "$out/share/bash-completion/completions/eruption-macro"
    cp "support/shell/completions/en_US/eruption-keymap.bash-completion" "$out/share/bash-completion/completions/eruption-keymap"
    cp "support/shell/completions/en_US/eruption-netfx.bash-completion" "$out/share/bash-completion/completions/eruption-netfx"
    cp "support/shell/completions/en_US/eruption-fx-proxy.bash-completion" "$out/share/bash-completion/completions/eruption-fx-proxy"
    cp "support/shell/completions/en_US/eruption-audio-proxy.bash-completion" "$out/share/bash-completion/completions/eruption-audio-proxy"
    cp "support/shell/completions/en_US/eruption-process-monitor.bash-completion" "$out/share/bash-completion/completions/eruption-process-monitor"
    cp "support/shell/completions/en_US/eruptionctl.bash-completion" "$out/share/bash-completion/completions/eruptionctl"
    cp "support/shell/completions/en_US/eruption-cmd.fish-completion" "$out/share/fish/completions/eruption-cmd.fish"
    cp "support/shell/completions/en_US/eruption-hwutil.fish-completion" "$out/share/fish/completions/eruption-hwutil.fish"
    cp "support/shell/completions/en_US/eruption-debug-tool.fish-completion" "$out/share/fish/completions/eruption-debug-tool.fish"
    cp "support/shell/completions/en_US/eruption-macro.fish-completion" "$out/share/fish/completions/eruption-macro.fish"
    cp "support/shell/completions/en_US/eruption-keymap.fish-completion" "$out/share/fish/completions/eruption-keymap.fish"
    cp "support/shell/completions/en_US/eruption-netfx.fish-completion" "$out/share/fish/completions/eruption-netfx.fish"
    cp "support/shell/completions/en_US/eruption-fx-proxy.fish-completion" "$out/share/fish/completions/eruption-fx-proxy.fish"
    cp "support/shell/completions/en_US/eruption-audio-proxy.fish-completion" "$out/share/fish/completions/eruption-audio-proxy.fish"
    cp "support/shell/completions/en_US/eruption-process-monitor.fish-completion" "$out/share/fish/completions/eruption-process-monitor.fish"
    cp "support/shell/completions/en_US/eruptionctl.fish-completion" "$out/share/fish/completions/eruptionctl.fish"
    cp "support/shell/completions/en_US/eruption-cmd.zsh-completion" "$out/share/zsh/site-functions/_eruption-cmd"
    cp "support/shell/completions/en_US/eruption-hwutil.zsh-completion" "$out/share/zsh/site-functions/_eruption-hwutil"
    cp "support/shell/completions/en_US/eruption-debug-tool.zsh-completion" "$out/share/zsh/site-functions/_eruption-debug-tool"
    cp "support/shell/completions/en_US/eruption-macro.zsh-completion" "$out/share/zsh/site-functions/_eruption-macro"
    cp "support/shell/completions/en_US/eruption-keymap.zsh-completion" "$out/share/zsh/site-functions/_eruption-keymap"
    cp "support/shell/completions/en_US/eruption-netfx.zsh-completion" "$out/share/zsh/site-functions/_eruption-netfx"
    cp "support/shell/completions/en_US/eruption-fx-proxy.zsh-completion" "$out/share/zsh/site-functions/_eruption-fx-proxy"
    cp "support/shell/completions/en_US/eruption-audio-proxy.zsh-completion" "$out/share/zsh/site-functions/_eruption-audio-proxy"
    cp "support/shell/completions/en_US/eruption-process-monitor.zsh-completion" "$out/share/zsh/site-functions/_eruption-process-monitor"
    cp "support/shell/completions/en_US/eruptionctl.zsh-completion" "$out/share/zsh/site-functions/_eruptionctl"

    cp "support/sfx/typewriter1.wav" "$out/usr/share/eruption/sfx/"
    cp "support/sfx/phaser1.wav" "$out/usr/share/eruption/sfx/"
    cp "support/sfx/phaser2.wav" "$out/usr/share/eruption/sfx/"

    cp "support/dbus/org.eruption.control.conf" "$out/share/dbus-1/system.d/"
    cp "support/dbus/org.eruption.process_monitor.conf" "$out/share/dbus-1/session.d/"
    cp "support/dbus/org.eruption.fx_proxy.conf" "$out/share/dbus-1/session.d/"

    cp "support/policykit/org.eruption.policy" "$out/share/polkit-1/actions/"

    cp "support/udev/99-eruption.rules" "$out/lib/udev/rules.d/"

    cp "support/systemd/eruption-suspend.sh" "$out/lib/systemd/system-sleep/eruption"
    cp "support/systemd/eruption.service" "$out/lib/systemd/system/"
    cp "support/systemd/eruption.preset" "$out/lib/systemd/system-preset/50-eruption.preset"
    cp "support/systemd/eruption-fx-proxy.service" "$out/lib/systemd/user/"
    cp "support/systemd/eruption-fx-proxy.preset" "$out/lib/systemd/user-preset/50-eruption-fx-proxy.preset"
    cp "support/systemd/eruption-audio-proxy.service" "$out/lib/systemd/user/"
    cp "support/systemd/eruption-audio-proxy.preset" "$out/lib/systemd/user-preset/50-eruption-audio-proxy.preset"
    cp "support/systemd/eruption-process-monitor.service" "$out/lib/systemd/user/"
    cp "support/systemd/eruption-process-monitor.preset" "$out/lib/systemd/user-preset/50-eruption-process-monitor.preset"
    cp "support/systemd/eruption-hotplug-helper.service" "$out/lib/systemd/system/"
    cp "support/systemd/eruption-hotplug-helper.preset" "$out/lib/systemd/system-preset/50-eruption-hotplug-helper.preset"

    chmod 0755 $out/lib/systemd/system-sleep/eruption

    ln -fs "phaser1.wav" "$out/usr/share/eruption/sfx/key-down.wav"
    ln -fs "phaser2.wav" "$out/usr/share/eruption/sfx/key-up.wav"

    cp -r eruption/src/scripts/* $out/usr/share/eruption/scripts/
    cp -r support/profiles/* $out/var/lib/eruption/profiles/

    sed $out/share/applications/eruption-gui-gtk3.desktop -i -e "{s#/usr/bin#$out/bin#; s#keyboard-brightness-symbolic#$out/usr/share/icons/hicolor/64x64/apps/eruption-gui.png#}"
  '';

  meta = {
    description = "Realtime RGB LED Driver for Linux";
    license = lib.licenses.gpl3Plus;
    homepage = "https://eruption-project.org/";
    maintainers = with lib.maintainers; [ puckla ];
  };
}
