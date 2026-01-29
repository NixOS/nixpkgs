{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  # Similar to types.enum of `attrNames attrset`, but maps merged result to `attrset.${value}`
  attrEnum =
    attrset:
    types.enum (lib.attrNames attrset)
    // {
      merge = loc: defs: attrset.${lib.mergeEqualOption loc defs};
      functor = types.enum.functor // {
        type = attrEnum;
        payload = attrset;
        binOp = a: b: a // b;
      };
    };

  /*
    Credential handling pipeline:
    - Buildtime
      - User calls `mkSecret` for every value expected to be substituted at runtime
      - credential.finalize recursively traverses configuration inserting placeholder values like "@<id>@"
    - Runtime
      - Systemd ensures that given path exists (`RequiresMountsFor` and `AssertPathExists`)
      - Systemd reads value of each credential to `$CREDENTIALS_DIRECTORY/<id>`
      - loadCredentialsScript copies config files from /nix/store to /tmp and finally substitutes credentials
  */
  credAttrType = "_credentialFilePath";
  credType = types.addCheck types.attrs (attrs: attrs ? ${credAttrType}) // {
    merge = loc: defs: {
      ${credAttrType} =
        let
          path = (lib.mergeEqualOption loc defs).${credAttrType};
          id = builtins.hashString "sha256" path;
        in
        {
          inherit path id;
        };
    };
  };
  credSubstituteRec =
    x:
    if credType.check x then
      "@${x.${credAttrType}.id}@"
    else if lib.isList x then
      map credSubstituteRec x
    else if lib.isAttrs x then
      lib.mapAttrs (_: v: credSubstituteRec v) x
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

      intOrAttrEnum =
        attrset: description:
        lib.mkOption {
          type = with types; nullOr (either int (attrEnum attrset));
          default = null;
          inherit description;
        };

      # Hopefully helpful enum mappings
      templates = {
        # https://i2pd.readthedocs.io/en/latest/user-guide/tunnels/#i2cp-parameters
        i2cp = {
          leaseSetType = intOrAttrEnum {
            "standard" = 3;
            "encrypted" = 5;
          } "Type of LeaseSet to be sent";
          leaseSetEncType = intOrAttrEnum {
            "ELGAMAL" = 0;
            "ECIES_P256_SHA256_AES256CBC" = 1;
            "ECIES_X25519_AEAD" = 4;
            "ECIES_MLKEM512_X25519_AEAD" = 5;
            "ECIES_MLKEM768_X25519_AEAD" = 6;
            "ECIES_MLKEM1024_X25519_AEAD" = 7;
          } "List of LeaseSet encryption types";
          leaseSetAuthType = intOrAttrEnum {
            "none" = 0;
            "DH" = 1;
            "PSK" = 2;
          } "Authentication type for encrypted LeaseSet";
        };
        i2p.streaming.profile = intOrAttrEnum {
          "bulk" = 1;
          "interactive" = 2;
        } "Bandwidth usage profile";
        # This option is part of both client and server tunnels, but not documented as i2cp parameter
        signaturetype =
          intOrAttrEnum
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
      package = lib.mkOption {
        type = types.package;
        default = pkgs.i2pd;
        defaultText = lib.literalExpression "pkgs.i2pd";
        description = "i2pd package to use";
      };
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
      config = lib.mkOption {
        description = ''
          Free-form main i2pd configuration. Options are passed to `i2pd.conf`.
          See <https://i2pd.readthedocs.io/en/latest/user-guide/configuration/>
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
              ];
              default = "error";
              description = "The log level";
            };
            bandwidth = lib.mkOption {
              type =
                with types;
                nullOr (oneOf [
                  int
                  (enum [
                    "L"
                    "O"
                    "P"
                    "X"
                  ])
                  (attrEnum {
                    "32KBps" = "L";
                    "256KBps" = "O";
                    "2048KBps" = "P";
                    "UNLIMITED" = "X";
                  })
                ]);
              default = null;
              description = ''
                Set a router bandwidth limit: integer in KBps or alias.
                Note that integer bandwidth will be rounded.
                If not set, i2pd defaults to `32KBps`.
              '';
            };
          };
          config = lib.mapAttrsRecursive (_: v: lib.mkDefault v) {
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
        default = { };
        example = lib.literalExpression ''
          {
            meshnets.yggdrasil = true; # Enable yggdrasil network support
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
        example = {
          # Taken from i2pd's contrib/tunnels.conf
          "irc-ilita" = {
            address = "127.0.0.1";
            port = 6668;
            destination = "irc.ilita.i2p";
            destinationport = 6667;
            keys = "irc-keys.dat";
            i2p.streaming.profile = "interactive";
          };
        };
      };

      mkSecret = lib.mkOption {
        type = types.anything // {
          description = "Function that takes absolute path to runtime credential file";
        };
        readOnly = true;
        default =
          path:
          if types.path.check path then
            { ${credAttrType} = path; }
          else
            throw "Argument to `mkSecret` is not of type `lib.types.path`";
        description = ''
          Substitute value of any free-formed option with contents of the provided file.
          The file is read at runtime before i2pd service starts, file permissions are ignored.
        '';
        example = lib.literalExpression ''
          { pkgs, lib, config, ... }:
          let
            mkSecret = config.services.i2pd.mkSecret;
          in
          {
            clientTunnels."example".destination = mkSecret "/run/secrets/example-tunnel-destination";
          }
        '';
      };
    };

  imports =
    let
      addPrefix = option: "services.i2pd.${option}";
      splitPath = option: lib.splitString "." (addPrefix option);
      # Same as `mkRemovedOptionModule`, but allows submodule options that may not always exists.
      prohibit =
        option:
        { config, ... }:
        {
          config.assertions = [
            {
              assertion = !lib.hasAttrByPath (splitPath option) config;
              message = "This option `${addPrefix option}` is used by i2pd module. Don't override it yourself.";
            }
          ];
        };
      rename = from: to: lib.mkRenamedOptionModule (splitPath from) (splitPath to);
    in
    [
      (prohibit "config.conf")
      (prohibit "config.tunconf")
      (prohibit "config.pidfile")
      (prohibit "config.log")
      (prohibit "config.logfile")
      (prohibit "config.datadir")
      (prohibit "config.daemon")
      (prohibit "config.service")
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

      # I2pd doesn't have an official config validator, but the daemon prints an error and exits
      # if some option is misspelled. This approach isn't great yet better than no check at all.
      # Note: misspellings in `tunnels.conf` or other kinds of errors aren't caught during build.
      # TODO: We're running `${lib.getExe cfg.package}` during the build, what if target arch is different?
      validateConfig =
        configPath:
        pkgs.runCommand "check-i2pd.conf" { }
          # sh
          ''
            set -euo pipefail

            echo Checking ${configPath}
            ${lib.getExe cfg.package} --loglevel=error --datadir=/build --conf=${configPath} 2>&1 \
              | grep 'unrecognised option' \
              | tee /build/check-output \
              &

            sleep 2
            test -z "$(cat /build/check-output)" || exit 1

            cp ${configPath} $out
          '';

      i2pdConfig = validateConfig (genConfig "i2pd.conf" (credSubstituteRec cfg.config));

      tunConfig = genTunnels "i2pd-tunnels.conf" (
        lib.mapAttrs' (k: v: lib.nameValuePair "client-${k}" (v // { "type" = "client"; })) (
          credSubstituteRec cfg.clientTunnels
        )
        // lib.mapAttrs' (k: v: lib.nameValuePair "server-${k}" (v // { "type" = "server"; })) (
          credSubstituteRec cfg.serverTunnels
        )
      );

      # List of all passed credentials: `[ { id = ...; path = ...; } ... ]`
      credentials = credCollectRec [
        cfg.config
        cfg.clientTunnels
        cfg.serverTunnels
      ];

      loadCredentialsScriptArgs = [
        # "%T" is temporary directory, usually `/tmp`
        "%T/conf=${i2pdConfig}"
        "%T/tunconf=${tunConfig}"
      ];

      loadCredentialsScript =
        pkgs.writeShellScript "i2pd-load-credentials"
          # sh
          ''
            set -euo pipefail

            # If no credential declared, `CREDENTIALS_DIRECTORY` is unset
            ids=(${"$"}{CREDENTIALS_DIRECTORY:+$(ls "$CREDENTIALS_DIRECTORY")})

            # For every cli argument
            for arg in "$@"; do
              # Split argument at "=", assign first part to `out` and second part to `in`
              arg=(${"$"}{arg//=/ })
              out="${"$"}{arg[0]}"
              in="${"$"}{arg[1]}"

              # Copy file, set permissions
              cp "$in" "$out"
              chmod u=rw,g=,o= "$out"

              # Try substitute all known credentials
              for id in "${"$"}{ids[@]}"; do
                ${lib.getExe pkgs.replace-secret} @"$id"@ "$CREDENTIALS_DIRECTORY/$id" "$out"
              done
            done
          '';

      i2pdCliArgs = lib.cli.toGNUCommandLineShell { } {
        "datadir" = "%S/i2pd"; # "%S" is systemd state directory, usually `/var/lib`
        "conf" = "%T/conf";
        "tunconf" = "%T/tunconf";
      };
    in
    lib.mkIf cfg.enable {
      systemd.services.i2pd = {
        description = "Minimal I2P router";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        unitConfig = rec {
          AssertPathExists = map (cred: cred.path) credentials;
          RequiresMountsFor = AssertPathExists;
        };

        serviceConfig = {
          DynamicUser = true;
          StateDirectory = [ "i2pd" ];

          # Load credentials
          LoadCredential = lib.forEach credentials (cred: "${cred.id}:${cred.path}");
          ExecStartPre = "${loadCredentialsScript} ${lib.escapeShellArgs loadCredentialsScriptArgs}";

          ExecStart = "${lib.getExe cfg.package} ${i2pdCliArgs}";
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
