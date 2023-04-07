{ config, lib, pkgs, ... }:

with lib;
let
  # TODO: Secrets handling

  # Simular to types.enum of `attrNames attrset` but maps merged result to `attrset.${value}`
  attrEnum = attrset:
    types.enum (attrNames attrset) // {
      merge = loc: defs: attrset.${mergeEqualOption loc defs};
      functor = types.enum.functor // { type = attrEnum; payload = attrset; binOp = a: b: a // b; };
    };
in
{
  ###### Interface #####

  options.services.i2pd =
    let
      # Type for free-form configuration options
      format = rec {
        type =
          with types;
          let base = [ bool int str ]; in
          attrsOf (nullOr (oneOf (base ++ [ (listOf (oneOf base)) type ])))
          // { description = "nested (bool, int, string or list of bool, int or string)"; };
      };

      # Hopefully helpful enum mappings
      templates = rec {
        attrEnum' = attrset: description:
          mkOption {
            type = with types; nullOr (either int (attrEnum attrset));
            default = null;
            description = mdDoc description;
          };
        # Common for all tunnels except exploratory
        # https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#i2cp-parameters
        i2cp = {
          leaseSetType = attrEnum'
            { "standard" = 3; "encrypted" = 5; }
            "Type of LeaseSet to be sent";
          leaseSetEncType = attrEnum'
            {
              "ELGAMAL" = 0;
              "ECIES_P256_SHA256_AES256CBC" = 1;
              "ECIES_X25519_AEAD" = 4;
            }
            "List of LeaseSet encryption types";
          leaseSetAuthType = attrEnum'
            {
              "none" = 0;
              "DH" = 1;
              "PSK" = 2;
            }
            "Authentication type for encrypted LeaseSet";
        };
        # This option is part of both client and server tunnels but not documented as i2cp parameter
        signaturetype = attrEnum'
          {
            "ECDSA-P256" = 1;
            "ECDSA-P384" = 2;
            "ECDSA-P521" = 3;
            "ED25519-SHA512" = 7;
            "GOSTR3410-A-GOSTR3411-256" = 9;
            "GOSTR3410-TC26-A-GOSTR3411-512" = 10;
            "RED25519-SHA512" = 11;
          }
          ''Signature type for new keys.
          `ED25519-SHA512` is default.
          `RED25519-SHA512` is recommended for encrypted leaseset.'';
      };
    in
    {
      enable = mkEnableOption (mdDoc "`i2pd` (I2P network router)");
      package = mkOption {
        type = types.package;
        default = pkgs.i2pd;
        defaultText = literalExpression "pkgs.i2pd";
        description = mdDoc "i2pd package to use";
      };
      gracefulShutdown = mkEnableOption "" // {
        description = mdDoc ''
          If true, i2pd will be wait for closing transit connections.
          Enabling this option **may delay system shutdown/reboot/rebuild-switch up to 10 minutes!**
        '';
      };
      autoRestart = mkEnableOption "" // {
        default = true;
        description = mdDoc "If true, i2pd will be restarted on failure (does not affect clean exit)";
      };
      config =
        mkOption {
          description = mdDoc ''
            Free-form main i2pd configuration. Options are directly propogated to `i2pd.conf`.
            See `https://i2pd.readthedocs.io/en/latest/user-guide/configuration/`
            Note: Free option values are unchecked.
          '';
          type = types.submodule {
            freeformType = format.type;
            options = {
              loglevel = mkOption {
                type = types.enum [ "debug" "info" "warn" "error" ];
                default = "error";
                description = mdDoc "The log level";
              };
              bandwidth = templates.attrEnum'
                ((a: a // listToAttrs (forEach (attrValues a) (k: nameValuePair k k)))
                  { "32KBps" = "L"; "256KBps" = "O"; "2048KBps" = "P"; "UNLIMITED" = "X"; })
                ''Set a router bandwidth limit: integer in KBps or word.
                Note that integer bandwith will be rounded.
                If not set, {command}`i2pd` defaults to 32KBps.'';
            };
            config = mapAttrsRecursive (_: mkDefault) {
              http.enabled = true;
              httpproxy.enabled = true;
              socksproxy.enabled = true;
              sam.enabled = false;
              bob.enabled = false;
              i2cp.enabled = false;
              i2pcontrol.enabled = false;

              precomputation.elgamal = true;
            };
          };
          example = ''
            {
              meshnets.yggdrasil = true; # Enable yggdrassil network support
            }
          '';
        };

      # Server/generic tunnels
      inTunnels = mkOption {
        description = mdDoc ''
          Free-form "server" tunnels. Options are directly propogated to `tunnels.conf`.
          See `https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#servergeneric-tunnels`
          Note: Free options are unchecked.
        '';
        type = types.attrsOf (types.submodule {
          freeformType = format.type;
          options = {
            host = mkOption {
              type = types.str;
              description = mdDoc "IP address of server (on this address i2pd will send data from I2P)";
            };
            port = mkOption {
              type = types.port;
              description = mdDoc "Port of server tunnel (on this port i2pd will send data from I2P)";
            };
            inherit (templates) signaturetype;
          } // templates.i2cp;
        });
        default = { };
      };

      # Client tunnels
      outTunnels = mkOption {
        description = mdDoc ''
          Free-form "client" tunnels. Options are directly propogated to `tunnels.conf`.
          See `https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#client-tunnels`
          Note: Free options are unchecked.
        '';
        type = types.attrsOf (types.submodule {
          freeformType = format.type;
          options = {
            port = mkOption {
              type = types.port;
              description = mdDoc "Port of client tunnel (on this port i2pd will receive data)";
            };
            destination = mkOption {
              type = types.str;
              description = mdDoc "Remote endpoint, I2P hostname or b32.i2p address";
            };
            inherit (templates) signaturetype;
          } // templates.i2cp;
        });
        default = { };
      };
    };

  imports =
    let
      # Replicates `mkRemovedOptionModule`
      deprecate = message: options:
        [
          ({ config, ... }: {
            config.assertions = forEach options (option: {
              assertion = ! hasAttrByPath (splitString "." option) config;
              message = "The option definition `config.${option}` no longer has any effect; please remove it.\n${message}";
            });
          })
        ];
    in
    deprecate "This option is defined by the module implementation."
      (map (v: "services.i2pd.config.${v}")
        [ "conf" "tunconf" "pidfile" "log" "logfile" "datadir" "daemon" "service" ]);

  ###### Implementation ######

  config =
    let
      cfg = config.services.i2pd;

      /* Configuration generator
      *  Simular to `pkgs.formats.ini`, but with few distinctions:
      *   * Out-of-section options are allowed and printed on top.
      *   * Nested sub-values (`a.b.c = ...`) coerced to (`"a.b.c" = ...`).
      */
      format =
        let
          print = v:
            if isList v
            then concatMapStringsSep "," print v
            else generators.mkValueStringDefault { } v;
          unwrapPrefixes = attrset:
            let
              unwrap = (prefix: attrset:
                concatLists
                  (mapAttrsToList
                    (k: v:
                      if isAttrs v
                      then unwrap (prefix + k + ".") v
                      else [{ name = prefix + k; value = v; }])
                    attrset));
            in
            listToAttrs
              (unwrap "" attrset);
          mkKeyValue = generators.mkKeyValueDefault { mkValueString = print; } " = ";
          removeNulls = filterAttrsRecursive (_: v: ! isNull v);
        in
        {
          config.generate = name: attrs:
            let
              toIni = attrset:
                generators.toINI
                  { inherit mkKeyValue; }
                  (removeNulls attrset);
            in
            pkgs.writeText name
              (strings.removePrefix "[general]\n"
                (toIni
                  { "general" = filterAttrs (_: v: ! isAttrs v) attrs; }) + "\n"
              + (toIni
                (mapAttrs (_: v: unwrapPrefixes v) (filterAttrs (_: v: isAttrs v) attrs))));

          tunnels.generate = name: attrs:
            (pkgs.formats.ini { listToValue = print; inherit mkKeyValue; }).generate name
              (mapAttrs (_: unwrapPrefixes) (removeNulls attrs));
        };

      # I2pd has no official config validator, but daemon prints an error and exits
      # if some option is misspelled. This approach is not great yet better than no check.
      # Note: Distortion of `tunnels.conf` brings no warnings
      validate.config = configPath:
        pkgs.runCommand "check-i2pd.conf"
          { nativeBuildInputs = [ cfg.package ]; }
          ''
            ${cfg.package}/bin/i2pd --loglevel=error --datadir=/build --conf=${configPath} 2>&1 |
              grep 'unrecognised option' |
              tee /build/check-output &
            sleep 2
            [ -z "$(cat /build/check-output)" ] && (cp ${configPath} $out; exit 0) || exit 1
          '';
    in
    mkIf cfg.enable {
      systemd.services.i2pd = {
        description = "Minimal I2P router";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "i2pd-dyn";
          DynamicUser = true;
          StateDirectory = [ "i2pd" ];
          ExecStart = "${cfg.package}/bin/i2pd ${
            cli.toGNUCommandLineShell { } {
              "datadir" =  "%S/i2pd"; # Must be unescaped. "%S" is systemd state directory (usually `/var/lib`)
              "conf" = validate.config
                (format.config.generate "i2pd.conf" cfg.config);
              "tunconf" = format.tunnels.generate "i2pd-tunnels.conf"
                (mapAttrs' (k: v: nameValuePair "out-${k}" (v // { "type" = "client"; })) cfg.outTunnels
                  // mapAttrs' (k: v: nameValuePair "in-${k}" (v // { "type" = "server"; })) cfg.inTunnels);
            }}";
          ## Auto restart
          Restart = if cfg.autoRestart then "on-failure" else "no";
          ## Graceful shutdown
          KillSignal = if cfg.gracefulShutdown then "SIGINT" else "SIGTERM";
          TimeoutStopSec = if cfg.gracefulShutdown then "10m" else "30s";
          SendSIGKILL = true;
          ## Hardening
          # Taken from https://github.com/archlinux/svntogit-community/blob/packages/i2pd/trunk/030-i2pd-systemd-service-hardening.patch
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateDevices = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          NoNewPrivileges = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          SystemCallFilter = "@system-service";
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          PrivateMounts = true;
          PrivateUsers = true;
          RemoveIPC = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
        };
      };
    };
}

