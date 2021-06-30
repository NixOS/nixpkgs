# Graphical {#sec-profile-graphical}

Defines a NixOS configuration with the Plasma 5 desktop. It's used by the
graphical installation CD.

It sets [`services.xserver.enable`](options.html#opt-services.xserver.enable),
[`services.xserver.displayManager.sddm.enable`](options.html#opt-services.xserver.displayManager.sddm.enable),
[`services.xserver.desktopManager.plasma5.enable`](options.html#opt-services.xserver.desktopManager.plasma5.enable),
and [`services.xserver.libinput.enable`](options.html#opt-services.xserver.libinput.enable) to true. It also
includes glxinfo and firefox in the system packages list.
