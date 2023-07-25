# Graphical {#sec-profile-graphical}

Defines a NixOS configuration with the Plasma 5 desktop. It's used by the
graphical installation CD.

It sets [](#opt-services.xserver.enable),
[](#opt-services.xserver.displayManager.sddm.enable),
[](#opt-services.xserver.desktopManager.plasma5.enable),
and [](#opt-services.xserver.libinput.enable) to true. It also
includes glxinfo and firefox in the system packages list.
