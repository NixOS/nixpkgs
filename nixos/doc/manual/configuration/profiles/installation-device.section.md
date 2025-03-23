# Installation Device {#sec-profile-installation-device}

Provides a basic configuration for installation devices like CDs.
This enables redistributable firmware, includes the
[Clone Config profile](#sec-profile-clone-config)
and a copy of the Nixpkgs channel, so `nixos-install`
works out of the box.

Documentation for [Nixpkgs](#opt-documentation.enable)
and [NixOS](#opt-documentation.nixos.enable) are
forcefully enabled (to override the
[Minimal profile](#sec-profile-minimal) preference); the
NixOS manual is shown automatically on TTY 8, udisks is disabled.
Autologin is enabled as `nixos` user, while passwordless
login as both `root` and `nixos` is possible.
Passwordless `sudo` is enabled too.
[wpa_supplicant](#opt-networking.wireless.enable) is
enabled, but configured to not autostart.

It is explained how to login, start the ssh server, and if available,
how to start the display manager.

Several settings are tweaked so that the installer has a better chance of
succeeding under low-memory environments.
