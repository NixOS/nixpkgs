{ config, pkgs, lib, ... }:
let
  cfg = config.services.keter;
<<<<<<< HEAD
  yaml = pkgs.formats.yaml { };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
{
  meta = {
    maintainers = with lib.maintainers; [ jappie ];
  };

<<<<<<< HEAD
  imports = [
    (lib.mkRenamedOptionModule [ "services" "keter" "keterRoot" ] [ "services" "keter" "root" ])
    (lib.mkRenamedOptionModule [ "services" "keter" "keterPackage" ] [ "services" "keter" "package" ])
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  options.services.keter = {
    enable = lib.mkEnableOption (lib.mdDoc ''keter, a web app deployment manager.
Note that this module only support loading of webapps:
Keep an old app running and swap the ports when the new one is booted.
'');

<<<<<<< HEAD
    root = lib.mkOption {
=======
    keterRoot = lib.mkOption {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      type = lib.types.str;
      default = "/var/lib/keter";
      description = lib.mdDoc "Mutable state folder for keter";
    };

<<<<<<< HEAD
    package = lib.mkOption {
=======
    keterPackage = lib.mkOption {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      type = lib.types.package;
      default = pkgs.haskellPackages.keter;
      defaultText = lib.literalExpression "pkgs.haskellPackages.keter";
      description = lib.mdDoc "The keter package to be used";
    };

<<<<<<< HEAD

    globalKeterConfig = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yaml.type;
        options = {
          ip-from-header = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = lib.mdDoc "You want that ip-from-header in the nginx setup case. It allows nginx setting the original ip address rather then it being localhost (due to reverse proxying)";
          };
          listeners = lib.mkOption {
            default = [{ host = "*"; port = 6981; }];
            type = lib.types.listOf (lib.types.submodule {
              options = {
                host = lib.mkOption {
                  type = lib.types.str;
                  description = lib.mdDoc "host";
                };
                port = lib.mkOption {
                  type = lib.types.port;
                  description = lib.mdDoc "port";
                };
              };
            });
            description = lib.mdDoc ''
              You want that ip-from-header in
              the nginx setup case.
              It allows nginx setting the original ip address rather
              then it being localhost (due to reverse proxying).
              However if you configure keter to accept connections
              directly you may want to set this to false.'';
          };
          rotate-logs = lib.mkOption {
            default = false;
            type = lib.types.bool;
            description = lib.mdDoc ''
              emits keter logs and it's applications to stderr.
              which allows journald to capture them.
              Set to true to let keter put the logs in files
              (useful on non systemd systems, this is the old approach
              where keter handled log management)'';
          };
        };
      };
      description = lib.mdDoc "Global config for keter, see <https://github.com/snoyberg/keter/blob/master/etc/keter-config.yaml> for reference";
=======
    globalKeterConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ip-from-header = true;
        listeners = [{
          host = "*4";
          port = 6981;
        }];
      };
      # You want that ip-from-header in the nginx setup case
      # so it's not set to 127.0.0.1.
      # using a port above 1024 allows you to avoid needing CAP_NET_BIND_SERVICE
      defaultText = lib.literalExpression ''
        {
          ip-from-header = true;
          listeners = [{
            host = "*4";
            port = 6981;
          }];
        }
      '';
      description = lib.mdDoc "Global config for keter";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    bundle = {
      appName = lib.mkOption {
        type = lib.types.str;
        default = "myapp";
        description = lib.mdDoc "The name keter assigns to this bundle";
      };

      executable = lib.mkOption {
        type = lib.types.path;
        description = lib.mdDoc "The executable to be run";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "example.com";
        description = lib.mdDoc "The domain keter will bind to";
      };

      publicScript = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc ''
          Allows loading of public environment variables,
          these are emitted to the log so it shouldn't contain secrets.
        '';
        example = "ADMIN_EMAIL=hi@example.com";
      };

      secretScript = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "Allows loading of private environment variables";
        example = "MY_AWS_KEY=$(cat /run/keys/AWS_ACCESS_KEY_ID)";
      };
    };

  };

  config = lib.mkIf cfg.enable (
    let
<<<<<<< HEAD
      incoming = "${cfg.root}/incoming";
=======
      incoming = "${cfg.keterRoot}/incoming";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)


      globalKeterConfigFile = pkgs.writeTextFile {
        name = "keter-config.yml";
<<<<<<< HEAD
        text = (lib.generators.toYAML { } (cfg.globalKeterConfig // { root = cfg.root; }));
=======
        text = (lib.generators.toYAML { } (cfg.globalKeterConfig // { root = cfg.keterRoot; }));
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      # If things are expected to change often, put it in the bundle!
      bundle = pkgs.callPackage ./bundle.nix
        (cfg.bundle // { keterExecutable = executable; keterDomain = cfg.bundle.domain; });

      # This indirection is required to ensure the nix path
      # gets copied over to the target machine in remote deployments.
      # Furthermore, it's important that we use exec to
      # run the binary otherwise we get process leakage due to this
      # being executed on every change.
      executable = pkgs.writeShellScript "bundle-wrapper" ''
        set -e
        ${cfg.bundle.secretScript}
        set -xe
        ${cfg.bundle.publicScript}
        exec ${cfg.bundle.executable}
      '';

    in
    {
      systemd.services.keter = {
        description = "keter app loader";
        script = ''
          set -xe
          mkdir -p ${incoming}
<<<<<<< HEAD
          ${lib.getExe cfg.package} ${globalKeterConfigFile};
=======
          { tail -F ${cfg.keterRoot}/log/keter/current.log -n 0 & ${cfg.keterPackage}/bin/keter ${globalKeterConfigFile}; }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        '';
        wantedBy = [ "multi-user.target" "nginx.service" ];

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
        };

        after = [
          "network.target"
          "local-fs.target"
          "postgresql.service"
        ];
      };

      # On deploy this will load our app, by moving it into the incoming dir
      # If the bundle content changes, this will run again.
      # Because the bundle content contains the nix path to the executable,
      # we inherit nix based cache busting.
      systemd.services.load-keter-bundle = {
        description = "load keter bundle into incoming folder";
        after = [ "keter.service" ];
        wantedBy = [ "multi-user.target" ];
        # we can't override keter bundles because it'll stop the previous app
        # https://github.com/snoyberg/keter#deploying
        script = ''
          set -xe
          cp ${bundle}/bundle.tar.gz.keter ${incoming}/${cfg.bundle.appName}.keter
        '';
        path = [
          executable
          cfg.bundle.executable
        ]; # this is a hack to get the executable copied over to the machine.
      };
    }
  );
}
