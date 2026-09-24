{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  coerceMap =
    mapping: finalType:
    types.coercedTo (types.enum (lib.attrNames mapping)) (x: mapping.${x}) finalType;

  /*
    Credential handling pipeline:
    - Buildtime
      - User sets { _secret = ...; } for every value expected to be substituted at runtime
      - credential.finalize recursively traverses configuration inserting placeholder values like "<id>"
    - Runtime
      - Systemd ensures that given path exists (`RequiresMountsFor`)
      - Systemd reads value of each credential to `$CREDENTIALS_DIRECTORY/<id>`
      - loadCredentialsScript copies config files from /nix/store to /tmp and finally substitutes credentials
  */
  credAttrType = "_secret";
  credPlaceholderAttrType = "_secretPlaceholder";
  credType = types.addCheck types.attrs (attrs: attrs ? ${credAttrType}) // {
    merge = loc: defs: {
      ${credAttrType} =
        let
          def = lib.mergeEqualOption loc defs;
          val = def.${credAttrType};
          path =
            if types.path.check val then
              val
            else
              throw "Provided `{ ${credAttrType} = ...; }` is not of type `lib.types.path`";
          id = builtins.hashString "sha256" path;
          placeholder = if def ? ${credPlaceholderAttrType} then def.${credPlaceholderAttrType} else id;
        in
        {
          inherit path id placeholder;
        };
    };
  };
  credSubstituteRec =
    attr: x:
    if credType.check x then
      x.${credAttrType}.${attr}
    else if lib.isList x then
      map (credSubstituteRec attr) x
    else if lib.isAttrs x then
      lib.mapAttrs (_: v: credSubstituteRec attr v) x
    else
      x;
  credCollectRec =
    x:
    if credType.check x then
      [ x.${credAttrType} ]
    else if lib.isList x then
      lib.flatten (lib.map credCollectRec x)
    else if lib.isAttrs x then
      lib.flatten (lib.mapAttrsToList (_: v: credCollectRec v) x)
    else
      [ ];
in
{
  ###### Interface #####

  options.services.i2pd =
    let
      freeformType =
        with types;
        let
          base = [
            bool
            int
            str
            credType
          ];
        in
        attrsOf (
          nullOr (
            oneOf (
              base
              ++ [
                (listOf (oneOf base))
                freeformType
              ]
            )
          )
        )
        // {
          description = "nested (bool, int, string or list of bool, int or string)";
        };

      intOrCoerceMap =
        mapping: description:
        lib.mkOption {
          type = with types; nullOr (coerceMap mapping int);
          default = null;
          inherit description;
        };

      # Hopefully helpful enum mappings
      templates = {
        # https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#i2cp-parameters
        i2cp = {
          leaseSetType = intOrCoerceMap {
            "standard" = 3;
            "encrypted" = 5;
          } "Type of LeaseSet to be sent";
          leaseSetEncType = intOrCoerceMap {
            "ELGAMAL" = 0;
            "ECIES_P256_SHA256_AES256CBC" = 1;
            "ECIES_X25519_AEAD" = 4;
            "ECIES_MLKEM512_X25519_AEAD" = 5;
            "ECIES_MLKEM768_X25519_AEAD" = 6;
            "ECIES_MLKEM1024_X25519_AEAD" = 7;
          } "List of LeaseSet encryption types";
          leaseSetAuthType = intOrCoerceMap {
            "none" = 0;
            "DH" = 1;
            "PSK" = 2;
          } "Authentication type for encrypted LeaseSet";
        };
        i2p.streaming.profile = intOrCoerceMap {
          "bulk" = 1;
          "interactive" = 2;
        } "Bandwidth usage profile";
        # This option is part of both client and server tunnels, but not documented as i2cp parameter
        signaturetype =
          intOrCoerceMap
            {
              "ECDSA-P256" = 1;
              "ECDSA-P384" = 2;
              "ECDSA-P521" = 3;
              "ED25519-SHA512" = 7;
              "GOSTR3410-A-GOSTR3411-256" = 9;
              "GOSTR3410-TC26-A-GOSTR3411-512" = 10;
              "RED25519-SHA512" = 11;
              "ML-DSA-44" = 12;
            }
            ''
              Signature type for new keys.
              `ED25519-SHA512` is default.
              `RED25519-SHA512` is recommended for encrypted leaseset.
            '';
      };
    in
    {
      enable = lib.mkEnableOption "`i2pd` (I2P network router)";
      package = lib.mkPackageOption pkgs "i2pd" { };
      gracefulShutdown = lib.mkEnableOption "" // {
        description = ''
          If true, i2pd will wait for transit connections to close.
          Enabling this option **may delay system shutdown/reboot/rebuild-switch up to 10 minutes!**
        '';
      };
      autoRestart = lib.mkEnableOption "" // {
        default = true;
        description = "If true, i2pd will be restarted on failure (does not affect clean exit)";
      };
      settings = lib.mkOption {
        description = ''
          Free-form main i2pd configuration. Options are passed to `i2pd.conf`.
          See <https://i2pd.readthedocs.io/en/latest/user-guide/configuration/>

          Any free-formed option value can be substituted with contents of a
          provided file by setting it to `{ ${credAttrType} = <path>; }`. The
          file is read **at runtime** before i2pd service starts, file
          permissions are ignored.
        '';
        type = types.submodule {
          inherit freeformType;
          options = {
            loglevel = lib.mkOption {
              type = types.enum [
                "debug"
                "info"
                "warn"
                "error"
                "critical"
                "none"
              ];
              default = "error";
              description = "The log level";
            };
            bandwidth = lib.mkOption {
              type =
                with types;
                nullOr (
                  coerceMap
                    {
                      "32KBps" = "L";
                      "256KBps" = "O";
                      "2048KBps" = "P";
                      "UNLIMITED" = "X";
                    }
                    (oneOf [
                      ints.positive
                      (enum [
                        "L"
                        "O"
                        "P"
                        "X"
                      ])
                    ])
                );
              default = null;
              description = ''
                Set a router bandwidth limit: integer in KBps or alias.
                Note that integer bandwidth will be rounded.
                If not set, i2pd defaults to `32KBps`.
              '';
            };
          };
          config = {
            http.enabled = lib.mkDefault true;
            httpproxy.enabled = lib.mkDefault true;
            socksproxy.enabled = lib.mkDefault true;
            sam.enabled = lib.mkDefault false;
            bob.enabled = lib.mkDefault false;
            i2cp.enabled = lib.mkDefault false;
            i2pcontrol.enabled = lib.mkDefault false;

            precomputation.elgamal = lib.mkDefault true;

            # Overridden as CLI args
            conf = null;
            tunconf = null;
            datadir = null;
            # May not work as expected with DynamicUser=true
            pidfile = null;
            log = null;
            logfile = null;
            # May interfere with the systemd service
            daemon = null;
            service = null;
          };
        };
        default = { };
        example = lib.literalExpression ''
          {
            meshnets.yggdrasil = true; # Enable yggdrasil network support

            port = {
              ${credAttrType} = "/run/secrets/i2pd-port";
              ${credPlaceholderAttrType} = 0; # An optional placeholder value used when checking configuration
            };
          }
        '';
      };

      # Server/generic tunnels
      serverTunnels = lib.mkOption {
        description = ''
          Free-form "server" tunnels. Options are passed to `tunnels.conf`.
          Mnemonic: we serving some service to others.
          See <https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#servergeneric-tunnels>
        '';
        type = types.attrsOf (
          types.submodule {
            inherit freeformType;
            options = {
              host = lib.mkOption {
                type = types.either types.str credType;
                description = "IP address of server (on this address i2pd will send data from I2P)";
              };
              port = lib.mkOption {
                type = types.port;
                description = "Port of server tunnel (on this port i2pd will send data from I2P)";
              };
              inherit (templates) signaturetype i2cp i2p;
            };
          }
        );
        default = { };
      };

      # Client tunnels
      clientTunnels = lib.mkOption {
        description = ''
          Free-form "client" tunnels. Options are passed to `tunnels.conf`.
          Mnemonic: we connect to someone as a client.
          See <https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#client-tunnels>
        '';
        type = types.attrsOf (
          types.submodule {
            inherit freeformType;
            options = {
              port = lib.mkOption {
                type = types.port;
                description = "Port of client tunnel (on this port i2pd will receive data)";
              };
              destination = lib.mkOption {
                type = types.either types.str credType;
                description = "Remote endpoint, I2P hostname or b32.i2p address";
              };
              inherit (templates) signaturetype i2cp i2p;
            };
          }
        );
        default = { };
        # Taken from i2pd's contrib/tunnels.conf
        # LiteralExpression prevents unpacking of `i2p.streaming.profile`
        example = lib.literalExpression ''
          {
            "irc-ilita" = {
              address = "127.0.0.1";
              port = 6668;
              destination = "irc.ilita.i2p";
              destinationport = 6667;
              keys = "irc-keys.dat";
              i2p.streaming.profile = "interactive";
            };
          }
        '';
      };

      # TODO: Remove in NixOS 27.11
      mkSecret = lib.mkOption {
        type = types.anything;
        readOnly = true;
        default =
          path:
          lib.warn "`mkSecret` function is deprecated. Replace it with `{ ${credAttrType} = <path>; }`" {
            ${credAttrType} = path;
          };
        description = "Deprecated. Use `{ ${credAttrType} = <path>; }` directly";
      };
    };

  imports =
    let
      option = option: lib.splitString "." "services.i2pd.${option}";
      rename = from: to: lib.mkRenamedOptionModule (option from) (option to);
    in
    [
      (rename "inTunnels" "serverTunnels")
      (rename "outTunnels" "clientTunnels")
    ];

  ###### Implementation ######

  config =
    let
      cfg = config.services.i2pd;

      /*
        Configuration generator. Similar to `pkgs.formats.ini`, but with few distinctions:
        - Out-of-section options are allowed and printed on top of a file.
        - Nested sub-values (`a.b.c = ...`) coerced to (`"a.b.c" = ...`).
      */
      unwrapPrefixes =
        attrset:
        let
          unwrap = (
            prefix: attrset:
            lib.concatLists (
              lib.mapAttrsToList (
                k: v:
                if lib.isAttrs v then
                  unwrap (prefix + k + ".") v
                else
                  [
                    {
                      name = prefix + k;
                      value = v;
                    }
                  ]
              ) attrset
            )
          );
        in
        lib.listToAttrs (unwrap "" attrset);

      removeNulls = lib.filterAttrsRecursive (_: v: !isNull v);

      # I2pd-style ini allows lists, dented by comma separated values, and spaces between key and value
      ini = pkgs.formats.iniWithGlobalSection {
        listToValue = lib.concatMapStringsSep "," (lib.generators.mkValueStringDefault { });
        mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
      };

      genConfig =
        name: attrs:
        ini.generate name {
          globalSection = removeNulls (lib.filterAttrs (_: v: !lib.isAttrs v) attrs);
          sections = removeNulls (
            lib.mapAttrs (_: v: unwrapPrefixes v) (lib.filterAttrs (_: v: lib.isAttrs v) attrs)
          );
        };

      genTunnels =
        name: attrs:
        ini.generate name {
          sections = (lib.mapAttrs (_: unwrapPrefixes) (removeNulls attrs));
        };

      gen = attr: {
        conf = genConfig "i2pd.conf" (credSubstituteRec attr cfg.settings);
        tunconf = genTunnels "i2pd-tunnels.conf" (
          lib.mapAttrs' (k: v: lib.nameValuePair "client-${k}" (v // { "type" = "client"; })) (
            credSubstituteRec attr cfg.clientTunnels
          )
          // lib.mapAttrs' (k: v: lib.nameValuePair "server-${k}" (v // { "type" = "server"; })) (
            credSubstituteRec attr cfg.serverTunnels
          )
        );
      };

      i2pdConfig = gen "id";
      i2pdCheckedConfig = gen "placeholder";

      # List of all passed credentials: `[ { id = ...; path = ...; } ... ]`
      credentials = credCollectRec [
        cfg.settings
        cfg.clientTunnels
        cfg.serverTunnels
      ];

      loadCredentialsScript =
        pkgs.writeShellScript "i2pd-load-credentials"
          # sh
          ''
            set -euo pipefail

            # If no credential declared, `CREDENTIALS_DIRECTORY` is unset
            ids=(''${CREDENTIALS_DIRECTORY:+$(ls "$CREDENTIALS_DIRECTORY")})

            # For every cli argument
            for arg in "$@"; do
              # Split argument at "=", assign first part to `out` and second part to `in`
              arg=(''${arg//=/ })
              out="''${arg[0]}"
              in="''${arg[1]}"

              # Copy file, set permissions
              cp "$in" "$out"
              chmod u=rw,g=,o= "$out"

              # Try substitute all known credentials
              for id in "''${ids[@]}"; do
                ${lib.getExe pkgs.replace-secret} "$id" "$CREDENTIALS_DIRECTORY/$id" "$out"
              done
            done
          '';
    in
    lib.mkIf cfg.enable {
      system.checks = lib.optional (with pkgs.stdenv; buildPlatform.system == hostPlatform.system) (
        pkgs.runCommand "services.i2pd.check-i2pd.conf" { }
          # sh
          ''
            set -euo pipefail
            i2pd="${lib.getExe cfg.package}"
            conf="${i2pdCheckedConfig.conf}"
            tunconf="${i2pdCheckedConfig.tunconf}"

            # Disable connectivity, in case build sandbox is disabled
            echo "ipv4 = false" >>conf
            echo "ipv6 = false" >>conf
            grep -Pv "^(ipv4|ipv6)[\s=]" "$conf" >>conf
            opts="$("$i2pd" --help | grep -Eo "^  --\S*port(udp)? arg" | sed "s/ arg\$/=0/g")"

            echo Checking "$conf"
            ok=
            while read line; do
              case "$line" in
                *none*i2pd*starting...*)
                  [[ -z "$ok" ]] && ok=1
                  kill -s INT $(cat pidfile)
                  ;;
                *critical*)
                  ok=0
                  ;;
              esac
            done < <(
              "$i2pd" \
                --pidfile=pidfile --loglevel=critical --datadir=datadir \
                --conf="$conf" --tunconf="$tunconf" \
                $opts 2>&1 \
                | tee /dev/stderr
            )
            [[ "$ok" != "1" ]] && exit 1

            touch $out
          ''
      );

      systemd.services.i2pd = {
        description = "Minimal I2P router";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          RequiresMountsFor = map (cred: cred.path) credentials;
        };

        serviceConfig = {
          User = "i2pd";
          Group = "i2pd";
          DynamicUser = true;
          StateDirectory = [ "i2pd" ];

          # Load credentials
          LoadCredential = lib.forEach credentials (cred: "${cred.id}:${cred.path}");
          ExecStartPre = lib.escapeShellArgs [
            loadCredentialsScript
            "%T/conf=${i2pdConfig.conf}" # "%T" is temporary directory, usually `/tmp`
            "%T/tunconf=${i2pdConfig.tunconf}"
          ];

          ExecStart = lib.escapeShellArgs [
            "${lib.getExe cfg.package}"
            "--datadir=%S/i2pd" # "%S" is systemd state directory, usually `/var/lib`
            "--conf=%T/conf"
            "--tunconf=%T/tunconf"
          ];
          Restart = if cfg.autoRestart then "on-failure" else "no";
          KillSignal = if cfg.gracefulShutdown then "SIGINT" else "SIGTERM";
          TimeoutStopSec = if cfg.gracefulShutdown then "10m" else "30s";
          SendSIGKILL = true;
          # Hardening
          # Taken from https://gitlab.archlinux.org/archlinux/packaging/packages/i2pd/-/blob/8b18a2084e3955fa14a1853fc7fcaa58cc05e21a/030-i2pd-systemd-service-hardening.patch
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

  meta = {
    maintainers = with lib.maintainers; [
      N4CH723HR3R
      one-d-wide
    ];
  };
}
