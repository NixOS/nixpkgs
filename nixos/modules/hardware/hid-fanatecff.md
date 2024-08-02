# Fanatec Wheelbases {#module-hid-fanatecff}

*Source:* {file}`modules/hardware/hid-fanatecff.nix`

*Upstream documentation:* <https://github.com/gotzl/hid-fanatecff>

`hid-fanatecff` is a kernel driver to support FANATEC input devices,
in particular ForceFeedback of various wheel-bases.

To enable `hid-fanatecff`, add the following to your
{file}`configuration.nix`:
```nix
{
  hardware.hid-fanatecff.enable = true;

  # If you want to use Oversteer
  users.YOUR_USERNAME.extraGroups = [ "games" ];
  services.udev.packages = with pkgs; [ oversteer ];
  environment.systemPackages = with pkgs; [ oversteer ];
}
```
