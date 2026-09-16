# Systemd compatibility layer for non-systemd service backends.
#
# When `system.systemdCompatibility.enable` is set (and `system.initSystem` is
# not "systemd"), this module provides:
#
#   - `system.build.systemdCompatibilityLayer`, a derivation with shim
#     binaries (`systemctl`, `systemd-run`, `journalctl`, `systemd-notify`,
#     `loginctl`, `systemd-analyze`) that translate the systemd CLI surface to
#     the active service backend's tools. The shims are added to the system
#     PATH via `environment.systemPackages` (opt-in, off by default).
#   - a `systemd-compat` modular service in the active backend that keeps the
#     system D-Bus bus supervised (dbus-daemon) so D-Bus based software keeps
#     working when systemd is not the init system.
#
# With `system.initSystem = "systemd"` (the default), nothing changes and
# compatibility code is not built.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.system.systemdCompatibility;
  initSystem = config.system.initSystem;

  # backend CLI translation table ------------------------------------------
  # Each entry maps a backend name to: the package providing the control
  # tool, the tool path, and command templates. Unit names are matched
  # without their type suffix.
  backend = {
    dinit = rec {
      package = pkgs.dinit;
      ctl = "${package}/bin/dinitctl";
      stop = name: "${ctl} stop ${name}";
      start = name: "${ctl} start ${name}";
      restart = name: "${ctl} restart ${name}";
      status = name: "${ctl} status ${name}";
      reboot = "${package}/bin/shutdown -r now";
      poweroff = "${package}/bin/shutdown -p now";
      logs = name: ''
        echo "dinit logs service (dinitctl show ${name}; catlog via dinitctl)" >&2
        ${ctl} show ${name} || true
      '';
    };
    runit = rec {
      package = pkgs.runit;
      ctl = "${package}/bin/sv";
      stop = name: "${ctl} down /etc/runit/services/${name}";
      start = name: "${ctl} up /etc/runit/services/${name}";
      restart = name: "${ctl} restart /etc/runit/services/${name}";
      status = name: "${ctl} status /etc/runit/services/${name}";
      reboot = "${pkgs.busybox}/bin/reboot";
      poweroff = "${pkgs.busybox}/bin/poweroff";
      logs = name: ''
        echo "runit logs for ${name}: svlogd output under /etc/runit/services/${name}/log" >&2
      '';
    };
    s6 = rec {
      package = pkgs.s6-rc;
      ctl = "${package}/bin/s6-rc";
      stop = name: "${ctl} -d change ${name}";
      start = name: "${ctl} -u change ${name}";
      restart = name: "${ctl} -d change ${name} && ${ctl} -u change ${name}";
      status = name: "${pkgs.s6}/bin/s6-svstat /run/service/${name}";
      reboot = "${pkgs.s6-linux-init}/bin/s6-reboot";
      poweroff = "${pkgs.s6-linux-init}/bin/s6-poweroff";
      logs = name: ''
        echo "s6 logs for ${name}: s6-log sink, consult the service's log/current" >&2
      '';
    };
  }.${initSystem};


  shims = pkgs.runCommand "systemd-compat-layer" { } (
    let
      tool =
        name: body:
        ''
          mkdir -p $out/bin
          cat > $out/bin/${name} <<'SHIMEOF'
          #!${pkgs.runtimeShell}
          # NixOS systemd compatibility shim for the ${initSystem} backend.
          ${body}
          SHIMEOF
          chmod +x $out/bin/${name}
        '';
    in
    ''
      ${tool "systemctl" ''
        cmd=''${1:-}
        case "''$cmd" in
          start|stop|restart|status|is-active)
            shift
            for u in "$@"; do
              u="''${u%.service}"
              u="''${u%.socket}"
              case "''$cmd" in
                start) ${backend.start "$u"} ;;
                stop) ${backend.stop "$u"} ;;
                restart) ${backend.restart "$u"} ;;
                *) ${backend.status "$u"} ;;
              esac
            done
            ;;
          is-enabled) echo 'enabled (NixOS-managed services are always enabled)' ;;
          enable|disable|preset|mask|unmask) echo "note: service enablement is managed by NixOS; nothing to do" ;;
          daemon-reload) echo "note: ${backend.ctl} does not need a reload" ;;
          reboot) exec ${backend.reboot} ;;
          poweroff) exec ${backend.poweroff} ;;
          halt) exec ${backend.poweroff} ;;
          list-units) echo "note: list units with ${backend.ctl}" ; ${backend.ctl} status || true ;;
          *)
            echo "systemctl (${initSystem} shim): unsupported command '$cmd'" >&2
            echo "supported: start, stop, restart, status, is-active, enable, disable, daemon-reload, reboot, poweroff" >&2
            exit 1 ;;
        esac
      ''}
      ${tool "systemd-run" ''
        echo "systemd-run (${initSystem} shim): transient services are not supported; define a modular service in system.services instead." >&2
        exit 2
      ''}
      ${tool "journalctl" ''
        echo "journalctl (${initSystem} shim): systemd journal is not available under ${initSystem}." >&2
      ''}
      ${tool "systemd-notify" ''
        # The s6 backend supports the SKA fd 4 notification protocol; under
        # other backends this shim is a no-op success.
        exit 0
      ''}
      ${tool "loginctl" ''
        echo "loginctl (${initSystem} shim): seat/login management is handled by the display manager." >&2
        exit 0
      ''}
      ${tool "systemd-analyze" ''
        echo "systemd-analyze (${initSystem} shim): timing analysis is not available under ${initSystem}." >&2
        exit 0
      ''}
    ''
  );

  dbusService = pkgs.writeShellScript "systemd-compat-dbus" ''
    exec ${pkgs.dbus}/bin/dbus-daemon --system --nofork
  '';
in
{
  _class = "nixos";

  options.system.systemdCompatibility = lib.mkOption {
    type = lib.types.submodule {
      options.enable = lib.mkEnableOption ''
        the systemd compatibility layer (shims for systemctl and related
        commands, and a supervised D-Bus service) when a non-systemd
        service backend is selected via system.initSystem
      '';
    };
    default = { };
    description = ''
      Compatibility layer for software that expects systemd, when NixOS runs
      with an alternative init system backend.
    '';
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = initSystem != "systemd";
        message = ''
          system.systemdCompatibility.enable requires system.initSystem to be
          set to a non-systemd backend (dinit, runit or s6); systemd does not
          need a compatibility layer.
        '';
      }
    ];

    environment.systemPackages = [ shims ];

    system.build.systemdCompatibilityLayer = shims;

    # Keep the system bus supervised by the active backend, with a restart
    # policy like systemd's dbus.service.
    system.services.systemd-compat = {
      process = {
        argv = [ dbusService ];
        type = "simple";
      };
      restart = {
        policy = "on-failure";
        delay = 5;
      };
    };
  };
}