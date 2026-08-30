{
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../common/openxr.nix ];

  # TODO(@Pandapip1): For the time being, Stardust doesn't like controllers rather than hand tracking
  services.monado.enable = lib.mkForce false;

  systemd.user.services.stardust-xr-server = {
    wantedBy = [ "xdg-desktop-autostart.target" ];
    # requires = [ "monado.service" ];
    serviceConfig = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${lib.getExe pkgs.stardust-xr-server} -e ${pkgs.writeShellScript "notifyReady" "systemd-notify --ready"}";
    };
    environment.RUST_BACKTRACE = "full";
  };
}
