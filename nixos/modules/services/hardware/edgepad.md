# Edgepad {#module-edgepad}

[Edgepad](https://github.com/assembledev/edgepad) maps touchpad edge gestures to commands.

This example binds the left edge to PipeWire volume control for `alice`.

```nix
{ pkgs, ... }:
{
  services.edgepad = {
    enable = true;
    users.alice.settings = {
      device = "auto";
      sliders = [
        {
          zone = "left";
          up = [
            "${pkgs.wireplumber}/bin/wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "3%+"
          ];
          down = [
            "${pkgs.wireplumber}/bin/wpctl"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "3%-"
          ];
        }
      ];
    };
  };
}
```

Logind grants the active seat user access to the touchpad and `/dev/uinput`.
The service starts with `graphical-session.target`. Check it from the user's session:

```sh
systemctl --user status edgepad.service
edgepad doctor --config "/etc/edgepad/$USER.toml"
```

Stop the daemon with `systemctl --user stop edgepad.service` to release the touchpad.
See the [upstream configuration reference](https://github.com/assembledev/edgepad/blob/main/docs/configuration.md)
for more settings.
