{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cryptpad;

  inherit (lib) mdDoc;

  # the config isn't json, but a js script which assigns a json value
  conf_file = builtins.toFile "cryptpad_config.js" ''
    module.exports = ${builtins.toJSON cfg.config}
  '';

  # Derive domain names for Nginx configuration from Cryptpad configuration
  mainDomain = lib.strings.removePrefix "https://" cfg.config.httpUnsafeOrigin;
  sandboxDomain = if isNull cfg.config.httpSafeOrigin then mainDomain else lib.strings.removePrefix "https://" cfg.config.httpSafeOrigin;
in {
  options.services.cryptpad = {
    enable = mkEnableOption (mdDoc "the Cryptpad service");

    package = mkOption {
      type = types.package;
      default = pkgs.cryptpad;
      defaultText = "pkgs.cryptpad";
      description = mdDoc "Cryptpad package to use";
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Manage cryptpad's nginx configuration.
          The virtual hostnames are derived from config.services.cryptpad.config.httpUnsafeOrigin and
          config.services.cryptpad.config.httpSafeOrigin
        '';
      };
    };

    confinement = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the nixos systemd.services.cryptpad.confinement setting, including the necessary
        extra bind mounts.
      '';
    };

    config = mkOption {
      description = mdDoc ''
        cryptpad backend settings.
        Some of the settings here (like backend ports) will be re-used for nginx config default as well
        See https://github.com/cryptpad/cryptpad/blob/main/config/config.example.js for more extensive
        comments and keys not described here
        Note paths cannot be changed easily as they are also present indirectly in the nginx config
        (for files that nginx serves directly)
        Once setup, test your instance through `https://<domain>/checkup/`
      '';
      type = types.submodule {
        freeformType = (pkgs.formats.json {}).type;
        options = {
          httpUnsafeOrigin = mkOption {
            type = types.str;
            example = "https://cryptpad.example.com";
            description = mdDoc "Main cryptpad domain url";
          };
          httpSafeOrigin = mkOption {
            type = types.nullOr types.str;
            example = "https://cryptpad-sandbox.example.com. Apparently optional but recommended.";
            description = mdDoc "Cryptpad sandbox url";
          };
          httpAddress = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Cryptpad listen address, also used in nginx to contact it";
          };
          httpPort = mkOption {
            type = types.int;
            default = 3000;
            description = mdDoc "Backend main port";
          };
          maxWorkers = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = mdDoc "Number of child processes, defaults to number of cores available";
          };
          adminKeys = mkOption {
            type = types.listOf types.str;
            default = [];
            description = mdDoc "Admins allowed to admin panel. Keys can be found in the settings page of the user";
            example = [ "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]" ];
          };
          logToStdout = mkOption {
            type = types.bool;
            default = true;
            description = mdDoc "Whether to log to stdout (will go to systemd service). Level can be changed with logLevel.";
          };
          blockDailyCheck = mkOption {
            type = types.bool;
            default = true;
            description = mdDoc "Disable telemetry. This setting is only effective if the 'Disable server telemetry' setting in the admin menu has been untouched, and will be ignored once set there either way.";
          };
          installMethod = mkOption {
            type = types.str;
            default = "nixos";
            description = mdDoc ''
              Install method is listed in telemetry if you agree to it through the consentToContact
              setting in the admin panel.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      users.users.cryptpad = {
        isSystemUser = true;
        group = "cryptpad";
      };
      users.groups.cryptpad = {};

      systemd.services.cryptpad = {
        description = "Cryptpad service";
        wantedBy = [ "multi-user.target" ];
        after = [ "networking.target" ];
        serviceConfig = {
          User = "cryptpad";
          Environment = [
            "CRYPTPAD_CONFIG=${conf_file}"
            "HOME=%S/cryptpad"
          ];
          ExecStart = "${cfg.package}/bin/cryptpad";
          PrivateTmp = true;
          Restart = "always";
          StateDirectory = "cryptpad";
          WorkingDirectory = "%S/cryptpad";
        };
      };
    }
    (mkIf cfg.confinement {
      systemd.services.cryptpad = {
        serviceConfig.BindReadOnlyPaths = [
          conf_file
          # apparently needs proc for workers management
          "/proc"
          "/dev/urandom"
        ] ++ (if ! cfg.config.blockDailyCheck then [
          "/etc/resolv.conf"
          "/etc/hosts"
        ] else []);
        confinement = {
          enable = true;
          binSh = null;
          mode = "chroot-only";
        };
      };
    })
    (mkIf cfg.nginx.enable {
      assertions = [
        { assertion = lib.strings.hasPrefix "https://" cfg.config.httpUnsafeOrigin;
          message = "services.cryptpad.config.httpUnsafeOrigin must start with https://";
        }
        { assertion = isNull cfg.config.httpSafeOrigin || lib.strings.hasPrefix "https://" cfg.config.httpSafeOrigin;
          message = "services.cryptpad.config.httpSafeOrigin must start with https:// (or be unset)";
        }
      ];
      services.nginx = {
        # FIXME: Check / compare this with [Nginx module configuration in nixpkgs](https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/web-servers/nginx/default.nix).
        # Find out why Cryptpad has this in their documetation. Does this decrease the security of a Cryptpad install
        # if not used?
        # diffie-hellman parameters are used to negotiate keys for your session
        # generate strong parameters using the following command
        # ssl_dhparam /etc/nginx/dhparam.pem; # openssl dhparam -out /etc/nginx/dhparam.pem 4096
        #
        # sslDhparam = null;

        # FIXME: Check / compare this with [Nginx module configuration in nixpkgs](https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/web-servers/nginx/default.nix).
        # Find out why Cryptpad has this in their documentation. Does this decrease the security of a Cryptpad install
        # if not used?
        # replace with the IP address of your resolver
        # resolver 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220;
        #
        # resolver = {};

        virtualHosts = mkMerge [
          {
            "${mainDomain}" = {
              serverAliases = if isNull cfg.config.httpSafeOrigin then [ ] else [ sandboxDomain ];
              enableACME = true;
              forceSSL = true;
              locations."/" = {
                proxyPass = "http://${cfg.config.httpAddress}:${builtins.toString cfg.config.httpPort}";
                proxyWebsockets = true;
                extraConfig = ''
                  client_max_body_size 150m;
                '';
              };
            };
          }
        ];
      };
    })
  ]);
}
