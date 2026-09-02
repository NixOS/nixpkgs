# An example plain-text secret backend written in Python.
{ config, lib, ... }:
let
  cfg = config.secrets.settings.store.plain;

  # We bake the configuration and required command into the script that calls
  # the CLI. I'm not sure if doing it this way is better than overriding the
  # Python writer directly. I guess this method shared the original Python
  # script derivation, but that might not be meaningful for such a small script.
  backendScript =
    pkgs: command:
    let
      backendJSONConfig = pkgs.writeText "plain.json" (
        builtins.toJSON {
          inherit (cfg) hostDirectory targetDirectory;
        }
      );

      scriptSource = builtins.readFile ./backend-plain.py;

      raw = pkgs.writers.writePython3Bin "secrets-plain-backend" {
        flakeIgnore = [
          "W191"
          "E501"
        ];
      } scriptSource;
    in
    lib.getExe (
      pkgs.symlinkJoin {
        name = "secrets-plain-backend";
        paths = [ raw ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/secrets-plain-backend \
            --add-flags "${backendJSONConfig} ${command}"
        '';
      }
    );
in
{
  options.secrets.settings.store.plain = {
    hostDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/secrets-ng-ng-plain/host/${config.networking.hostName}";
      description = ''
        The directory where the plain backend will store the secrets on the
        host machine.
      '';
    };

    targetDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/secrets-ng-ng-plain/target";
      description = ''
        The directory where the plain backend will store the secrets on the
        target machine.
      '';
    };
  };

  config.secrets.backends.store.plain = {
    get = pkgs: backendScript pkgs "get";
    set = pkgs: backendScript pkgs "set";
    exists = pkgs: backendScript pkgs "exists";
    list = pkgs: backendScript pkgs "list";
    delete = pkgs: backendScript pkgs "delete";
    deploy.local = pkgs: backendScript pkgs "deploy-local";

    fileModule =
      { secret, name, ... }:
      {
        path = "${cfg.targetDirectory}/${secret.name}/${name}";
      };
  };
}
