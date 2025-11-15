{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.throne;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "programs" "nekoray" ] [ "programs" "throne" ])
  ];

  options = {
    programs.throne = {
      enable = lib.mkEnableOption "Throne, a GUI proxy configuration manager";

      package = lib.mkPackageOption pkgs "throne" { };

      tunMode = {
        enable = lib.mkEnableOption "TUN mode of Throne";

        setuid = lib.mkEnableOption ''
          setting suid bit for throne-core to run as root, which is less
          secure than default setcap method but closer to upstream assumptions.
          Enable this if you find the default setcap method configured in
          this module doesn't work for you
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    security.wrappers.throne-core = lib.mkIf cfg.tunMode.enable {
      source = "${cfg.package}/share/throne/Core";
      owner = "root";
      group = "root";
      setuid = lib.mkIf cfg.tunMode.setuid true;
      # Taken from https://github.com/SagerNet/sing-box/blob/dev-next/release/config/sing-box.service
      capabilities = lib.mkIf (
        !cfg.tunMode.setuid
      ) "cap_net_admin,cap_net_raw,cap_net_bind_service,cap_sys_ptrace,cap_dac_read_search+ep";
    };

    # avoid resolvectl password prompt popping up three times
    # https://github.com/SagerNet/sing-tun/blob/0686f8c4f210f4e7039c352d42d762252f9d9cf5/tun_linux.go#L1062
    # We use a hack here to determine whether the requested process is throne-core
    # Detect whether its capabilities contain at least `net_admin` and `net_raw`.
    # This does not reduce security, as we can already bypass `resolved` with them.
    # Alternatives to consider:
    # 1. Use suid to execute as a specific user, and check username with polkit.
    #    However, NixOS module doesn't let us to set setuid and capabilities at the
    #    same time, and it's tricky to make both work together because of some security
    #    considerations in the kernel.
    # 2. Check cmdline to get executable path. This is insecure because the process can
    #    change its own cmdline. `/proc/<pid>/exe` is reliable but kernel forbids
    #    checking that entry of process from different users, and polkit runs `spawn`
    #    as an unprivileged user.
    # 3. Put throne-core into a systemd service, and let polkit check service name.
    #    This is the most secure and convenient way but requires heavy modification
    #    to Throne source code. Would be good to let upstream support that eventually.
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

  meta.maintainers = with lib.maintainers; [ aleksana ];
}
