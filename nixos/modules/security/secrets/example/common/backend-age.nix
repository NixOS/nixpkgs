# An example age-based secret backend written in Python.
#
# Note that unlike agenix, this backend does not copy the secret files to the
# Nix store, and as such requires an external deployment script. A more
# familiar implementation of an agenix-style backend is planned as a future
# example.
#
# Since we want deployments to be reasonably atomic, we create a tar file
# containing all the required secret files and push them to the target system
# through SSH. Do note that this means the files will stay decrypted at rest
# while on the target machine (barring disk encryption and the like). This is
# fine, as this is merely an example backend.
#
# An alternative implementation might choose to push the files as encrypted,
# and decode them at runtime (either during an activation or a systemd script,
# for example).
{
  config,
  lib,
  ...
}:
let
  cfg = config.secrets.settings.store.age;

  # This data will get encoded as JSON, and passed to every invocation of the
  # backend's CLI.
  ageNixConfig = {
    generators = lib.pipe config.secrets.store [
      (lib.filterAttrs (_: secrets: secrets.backend == "age"))
      (lib.mapAttrs' (
        _: secret: {
          inherit (secret) name;
          value = {
            inherit (secret.age) publicKeys;
            identity = { inherit (secret.age.identity) target host; };
          };
        }
      ))
    ];

    inherit (cfg)
      hostDirectory
      targetDirectory
      identity
      publicKeys
      ;
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
      raw = pkgs.writers.writePython3Bin "secrets-age-backend" {
        flakeIgnore = [
          "W191"
          "E501"
        ];
      } scriptSource;
    in
    lib.getExe (
      pkgs.symlinkJoin {
        name = "secrets-age-backend";
        paths = [ raw ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/secrets-age-backend \
            --set PATH ${cfg.package pkgs}/bin \
            --add-flags "${ageJSONConfig} ${command}"
        '';
        meta = { inherit (raw.meta) mainProgram; };
      }
    );
in
{
  options.secrets.settings.store.age = {
    package = lib.mkOption {
      type = lib.types.functionTo lib.types.pathInStore;
      default = pkgs: pkgs.age;
      description = "The package to use for the 'age' CLI";
    };

    hostDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/secrets-ng-ng-age/host/${config.networking.hostName}";
      description = ''
        The directory where the age backend will store encrypted secrets on the
        host machine.
      '';
    };

    targetDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/secrets-ng-ng-age/target";
      description = ''
        The directory where the age backend will store encrypted secrets on the
        target machine.
      '';
    };

    publicKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Age public keys to encrypt to";
    };

    identity.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        Path to the age private key file for decryption on the target machine
      '';

      example = "/var/lib/nixos-secrets/age.key";
    };

    identity.host = lib.mkOption {
      type = lib.types.str;
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

  options.secrets.store = lib.mkOption {
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
            type = lib.types.str;
            description = ''
              Path to the age private key file for decryption on the target
              machine
            '';
          };

          identity.host = lib.mkOption {
            default = cfg.identity.host;
            type = lib.types.str;
            description = ''
              Path to the age private key file for decryption on the host machine
            '';
          };
        };
      }
    );
  };

  config.secrets.backends.store.age = {
    get = pkgs: ageScript pkgs "get";
    set = pkgs: ageScript pkgs "set";
    list = pkgs: ageScript pkgs "list";
    delete = pkgs: ageScript pkgs "delete";
    fixup = pkgs: ageScript pkgs "fixup";
    deploy.local = pkgs: ageScript pkgs "deploy-local";

    # Python is not guaranteed to be installed on the target system. We
    # therefore write the portion of the script that runs on said system as a
    # simple shell script. While we can't technically guarantee that the
    # various coreutils CLIs will be in $PATH on the target system either, that
    # is a reasonable assumption to make (at least for an example
    # implementation).
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
      { secret, name, ... }:
      {
        path = "${cfg.targetDirectory}/${secret.name}/${name}";
      };
  };

  # TODO: write a service that decrypts the files at runtime! (or something...)
}
