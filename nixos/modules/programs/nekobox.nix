{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.nekobox;
in
{

  options = {
    programs.nekobox = {
      enable = lib.mkEnableOption "NekoBox, the proxy tool";

      package = lib.mkPackageOption pkgs "nekobox" { };

      tunMode = {
        enable = lib.mkEnableOption "TUN mode of NekoBox";

        setuid = lib.mkEnableOption ''
            Setting the suid bit for NekoBox is optional,
            unless you want to avoid prompting for password.
            The capabilities of the running process will be set
            every time TUN mode checked.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    security.wrappers.nekobox-core = lib.mkIf cfg.tunMode.enable {
      source = "${cfg.package}/libexec/Iblis/nekobox-core";
      owner = "root";
      group = "root";
      setuid = lib.mkIf cfg.tunMode.setuid true;
      # Taken from https://github.com/SagerNet/sing-box/blob/dev-next/release/config/sing-box.service
      capabilities = lib.mkIf (
        !cfg.tunMode.setuid
      ) "cap_net_admin,cap_net_raw,cap_net_bind_service,cap_sys_ptrace,cap_dac_read_search+ep";
    };

    # avoid resolvectl password prompt popping up three times
    # credits: aleksana
    security.polkit.extraConfig =
      lib.mkIf (cfg.tunMode.enable && (!cfg.tunMode.setuid) && config.services.resolved.enable)
        ''
          polkit.addRule(function(action, subject) {
            const allowedActionIds = [
              "org.freedesktop.resolve1.set-domains",
              "org.freedesktop.resolve1.set-default-route",
              "org.freedesktop.resolve1.set-dns-servers"
            ];

            if (allowedActionIds.indexOf(action.id) !== -1) {
              try {
                var parentPid = polkit.spawn(["${lib.getExe' pkgs.procps "ps"}", "-o", "ppid=", subject.pid]).trim();
                var parentCap = polkit.spawn(["${lib.getExe' pkgs.libcap "getpcaps"}", parentPid]).trim();
                if (parentCap.includes("cap_net_admin") && parentCap.includes("cap_net_raw")) {
                  return polkit.Result.YES;
                } else {
                  return polkit.Result.NOT_HANDLED;
                }
              } catch (e) {
                return polkit.Result.NOT_HANDLED;
              }
            }
          })
        '';
  };

  meta.maintainers = with lib.maintainers; [ qr243vbi ];
}
