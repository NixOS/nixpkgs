{ config, lib, ... }:
with lib;
{
  options.systemd.services = with types; mkOption {
    type = attrsOf (submodule ({ name, config, ... }: {
      options.sandbox = mkOption {
        description = ''
          Level of systemd service sandboxing for this particular unit.
          All systemd confinement options are overrridable by assigning
          another value to allow service-specific access.

          0 is no confinement at all.
          1 is basic sandboxing, probably not breaking anything.
          2 is the highest amount of sandboxing this module supports right now.
        '';
        default = 0;
        type = enum [ 0 1 2 ];
      };

      # mkDefault is 1000
      # assignment is 100
      # A value of 900 ensures that service defaults are overwritten, while
      # giving the administrator a chance to override by assigning.
      config.serviceConfig = mkMerge [
        (mkIf (config.sandbox >= 1) (mapAttrs (_: mkOverride 900) {
          # Filesystem stuff
          PrivateTmp = true; # Give an own directory under /tmp
          PrivateDevices = true; # Deny access to most of /dev
          ProtectKernelTunables = true; # Protect some parts of /sys
          ProtectControlGroups = true; # Remount cgroups read-only
          RestrictSUIDSGID = true; # Prevent creating SETUID/SETGID files

          # Kernel stuff
          ProtectKernelModules = true; # Prevent loading of kernel modules
          SystemCallArchitectures = "native"; # Usually no need to disable this
          PrivateMounts = true; # Give an own mount namespace

          # User
          User = warn "warning: ${name}.service is sandboxed but running as root." "root";

          # Misc
          LockPersonality = true; # Prevent change of the personality
          ProtectHostname = true; # Give an own UTS namespace
          RestrictRealtime = true; # Prevent switching to RT scheduling
        }))
        (mkIf (config.sandbox >= 2) (mapAttrs (_: mkOverride 900) {
          # Filesystem stuff
          ProtectSystem = "strict"; # Prevent writing to most of /
          ProtectHome = true; # Prevent accessing /home and /root

          # Capabilities
          CapabilityBoundingSet = ""; # Allow no capabilities at all
          NoNewPrivileges = true; # Disallow getting more capabilities (i.e. setcap files). This is also implied by other options.

          # Networking
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6"; # Disallow AF_PACKET, AF_NETLINK, ...
          PrivateNetwork = true; # Only give a dummy loopback interface

          # Misc
          MemoryDenyWriteExecute = true; # Maybe disable this for interpreters like python
          PrivateUsers = true; # If anything randomly breaks, it's mostly because of this
          SystemCallFilter = "@system-service"; # Only allow the most basic syscalls. See `systemd-analyze syscall-filter`.
        }))
      ];
    }));
  };

  meta.maintainers = with maintainers; [ das_j ajs124 ];
}
