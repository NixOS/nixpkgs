{ lib, ... }:
{
  _class = "service";

  config = {
    # Override the system-level default of `multi-user.target` (set at `mkDefault` priority 1000
    # in service.nix). `mkOverride 900` wins over `mkDefault` but loses to explicit user settings
    # (priority 100). The global `systemd.user.services` entry then forces `wantedBy = []` to
    # suppress auto-start system-wide; auto-start is wired per-user via the profile package.
    systemd.services."".wantedBy = lib.mkOverride 900 [ "default.target" ];
  };
}
