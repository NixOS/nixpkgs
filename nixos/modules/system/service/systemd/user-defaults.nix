{ lib, ... }:
{
  _class = "service";
  # Override the system default (multi-user.target) so user unit definitions
  # that rely on the default land on the correct user target.
  config.systemd.services."" = {
    wantedBy = lib.mkOverride 900 [ "default.target" ];
  };
}
