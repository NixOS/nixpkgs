{
  config,
  lib,
  ...
}:
let
  cfg = config.vars.age;

  # This data will get encoded as JSON, and passed to every invocation of the
  # backend's CLI.
  ageNixConfig = {
    generators = lib.pipe config.vars.generators [
      (lib.filterAttrs (_: generator: generator.backend == "age"))
      (lib.mapAttrs (
        _: generator: {
          inherit (generator.age) publicKeys;
          identity = { inherit (generator.age.identity) target host; };
        }
      ))
    ];

    inherit (cfg) hostDirectory targetDirectory;
  };

  # We bake the configuration and required command into the script that calls
  # the CLI. I'm not sure if doing it this way is better than overriding the
  # Python writer directly. I guess this method shared the original Python
  # script derivation, but that might not be meaningful for such a small script.
  ageScript =
    pkgs: command:
    let
      ageJSONConfig = pkgs.writeText "age.json" (builtins.toJSON ageNixConfig);
      scriptSource = builtins.readFile ./backend-age.py;
      raw = pkgs.writers.writePython3Bin "vars-age-backend" {
        flakeIgnore = [
          "W191"
          "E501"
        ];
      } scriptSource;
    in
    lib.getExe (
      pkgs.symlinkJoin {
        name = "vars-age-backend";
        paths = [ raw ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/vars-age-backend \
            --set PATH ${cfg.package pkgs}/bin \
            --add-flags "${ageJSONConfig} ${command}"
        '';
      }
    );
in
{
  options.vars.age = {
    package = lib.mkOption {
      type = lib.types.functionTo lib.types.pathInStore;
      default = pkgs: pkgs.age;
      description = "The package to use for the 'age' CLI";
    };

    hostDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vars-ng-ng-age/host/${config.networking.hostName}";
      description = ''
        The directory where the age backend will store encrypted variables on the
        host machine.
      '';
    };

    targetDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vars-ng-ng-age/target";
      description = ''
        The directory where the age backend will store encrypted variables on the
        target machine.
      '';
    };

    publicKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Age public keys to encrypt to";
    };

    identity.target = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.str
        lib.types.path
      ];

      description = ''
        Path to the age private key file for decryption on the target machine
      '';

      example = "/var/lib/nixos-vars/age.key";
    };

    identity.host = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.str
        lib.types.path
      ];

      description = ''
        Path to the age private key file for decryption on the host machine
      '';
    };

    ssh.identity = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The private key to use when deploying over SSH.
      '';
    };

    ssh.target = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "eve@example.com";
      description = ''
        The target to deploy files over SSH to.
      '';
    };
  };

  options.vars.generators = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.age = {
          publicKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = cfg.publicKeys;
            description = "Age public keys to encrypt to";
          };

          identity.target = lib.mkOption {
            default = cfg.identity.target;

            type = lib.types.oneOf [
              lib.types.str
              lib.types.path
            ];

            description = ''
              Path to the age private key file for decryption on the target
              machine
            '';
          };

          identity.host = lib.mkOption {
            default = cfg.identity.host;

            type = lib.types.oneOf [
              lib.types.str
              lib.types.path
            ];

            description = ''
              Path to the age private key file for decryption on the host machine
            '';
          };
        };
      }
    );
  };

  config.vars.generatorBackends.age = {
    get = pkgs: ageScript pkgs "get";
    set = pkgs: ageScript pkgs "set";
    exists = pkgs: ageScript pkgs "exists";
    list = pkgs: ageScript pkgs "list";
    delete = pkgs: ageScript pkgs "delete";
    fixup = pkgs: ageScript pkgs "fixup";
    deploy.local = pkgs: ageScript pkgs "deploy-local";
    deploy.remote = lib.mkIf (cfg.ssh.target != null) (
      pkgs:
      pkgs.writeScript "deploy-remote" ''
        #!/bin/sh
        set -euo pipefail
        ${ageScript pkgs "deploy"} | ssh "${cfg.ssh.target}" -i "${cfg.ssh.identity}" '
          # set -euo pipefail # <- Can't do this; the shell might not be bash :(
          mkdir -p "${cfg.targetDirectory}.tmp"
          tar xf - -C "${cfg.targetDirectory}.tmp"
          mv "${cfg.targetDirectory}.tmp" -T "${cfg.targetDirectory}"
        '
      ''
    );

    fileModule =
      { generator, name, ... }:
      {
        path = "${cfg.targetDirectory}/${generator.name}/${name}";
      };
  };

  # TODO: write a service that decrypts the files at runtime! (or something...)
}
