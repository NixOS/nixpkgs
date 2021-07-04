# Headless {#sec-profile-headless}

Common configuration for headless machines (e.g., Amazon EC2 instances).

Disables [sound](#opt-sound.enable),
[vesa](#opt-boot.vesa), serial consoles,
[emergency mode](#opt-systemd.enableEmergencyMode),
[grub splash images](#opt-boot.loader.grub.splashImage)
and configures the kernel to reboot automatically on panic.
