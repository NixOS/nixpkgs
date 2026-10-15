# systemd-lock-handler {#module-services-systemd-lock-handler}

The `systemd-lock-handler` module provides a service that bridges
D-Bus events from `logind` to user-level systemd targets:

  - `lock.target` started by `loginctl lock-session`,
  - `unlock.target` started by `loginctl unlock-session` and
  - `sleep.target` started by `systemctl suspend`.

You can create a user service that starts with any of these targets.

For example, to create a service for `swaylock`:

```nix
{
  services.systemd-lock-handler.enable = true;

  systemd.user.services.swaylock = {
    description = "Screen locker for Wayland";
    documentation = [ "man:swaylock(1)" ];

    # If swaylock exits cleanly, unlock the session:
    onSuccess = [ "unlock.target" ];

    # When lock.target is stopped, stops this too:
    partOf = [ "lock.target" ];

    # Delay lock.target until this service is ready:
    before = [ "lock.target" ];
    wantedBy = [ "lock.target" ];

    serviceConfig = {
      # systemd will consider this service started when swaylock forks...
      Type = "forking";

      # ... and swaylock will fork only after it has locked the screen.
      ExecStart = "${lib.getExe pkgs.swaylock} -f";

      # If swaylock crashes, always restart it immediately:
      Restart = "on-failure";
      RestartSec = 0;
    };
  };
}
```

See [upstream documentation](https://sr.ht/~whynothugo/systemd-lock-handler) for more information.
