{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.zope2;

  zope2Opts = { name, ... }: {
    options = {

      name = mkOption {
        default = "${name}";
        type = types.str;
        description = lib.mdDoc "The name of the zope2 instance. If undefined, the name of the attribute set will be used.";
      };

      threads = mkOption {
        default = 2;
        type = types.int;
        description = lib.mdDoc "Specify the number of threads that Zope's ZServer web server will use to service requests. ";
      };

      http_address = mkOption {
        default = "localhost:8080";
        type = types.str;
        description = lib.mdDoc "Give a port and address for the HTTP server.";
      };

      user = mkOption {
        default = "zope2";
        type = types.str;
        description = lib.mdDoc "The name of the effective user for the Zope process.";
      };

      clientHome = mkOption {
        default = "/var/lib/zope2/${name}";
        type = types.path;
        description = lib.mdDoc "Home directory of zope2 instance.";
      };
      extra = mkOption {
        default =
          ''
          <zodb_db main>
            mount-point /
            cache-size 30000
            <blobstorage>
                blob-dir /var/lib/zope2/${name}/blobstorage
                <filestorage>
                path /var/lib/zope2/${name}/filestorage/Data.fs
                </filestorage>
            </blobstorage>
          </zodb_db>
          '';
        type = types.lines;
        description = lib.mdDoc "Extra zope.conf";
      };

      packages = mkOption {
        type = types.listOf types.package;
        description = lib.mdDoc "The list of packages you want to make available to the zope2 instance.";
      };

    };
  };

in

{

  ###### interface

  options = {

    services.zope2.instances = mkOption {
      default = {};
      type = with types; attrsOf (submodule zope2Opts);
      example = literalExpression ''
        {
          plone01 = {
            http_address = "127.0.0.1:8080";
            extra =
              '''
              <zodb_db main>
                mount-point /
                cache-size 30000
                <blobstorage>
                    blob-dir /var/lib/zope2/plone01/blobstorage
                    <filestorage>
                    path /var/lib/zope2/plone01/filestorage/Data.fs
                    </filestorage>
                </blobstorage>
              </zodb_db>
              ''';
          };
        }
      '';
      description = lib.mdDoc "zope2 instances to be created automaticaly by the system.";
    };
  };

  ###### implementation

  config = mkIf (cfg.instances != {}) {

    users.users.zope2 = {
      isSystemUser = true;
      group = "zope2";
    };
    users.groups.zope2 = {};

    systemd.services =
      let

        createZope2Instance = opts: name:
          let
            interpreter = pkgs.writeScript "interpreter"
              ''
              import sys

              _interactive = True
              if len(sys.argv) > 1:
                  _options, _args = __import__("getopt").getopt(sys.argv[1:], 'ic:m:')
                  _interactive = False
                  for (_opt, _val) in _options:
                      if _opt == '-i':
                          _interactive = True
                      elif _opt == '-c':
                          exec _val
                      elif _opt == '-m':
                          sys.argv[1:] = _args
                          _args = []
                          __import__("runpy").run_module(
                              _val, {}, "__main__", alter_sys=True)

                  if _args:
                      sys.argv[:] = _args
                      __file__ = _args[0]
                      del _options, _args
                      execfile(__file__)

              if _interactive:
                  del _interactive
                  __import__("code").interact(banner="", local=globals())
              '';
            env = pkgs.buildEnv {
              name = "zope2-${name}-env";
              paths = [
                pkgs.python27
                pkgs.python27Packages.recursivePthLoader
                pkgs.python27Packages."plone.recipe.zope2instance"
              ] ++ attrValues pkgs.python27.modules
                ++ opts.packages;
              postBuild =
                ''
                echo "#!$out/bin/python" > $out/bin/interpreter
                cat ${interpreter} >> $out/bin/interpreter
                '';
            };
            conf = pkgs.writeText "zope2-${name}-conf"
              ''
              %define INSTANCEHOME ${env}
              instancehome $INSTANCEHOME
              %define CLIENTHOME ${opts.clientHome}/${opts.name}
              clienthome $CLIENTHOME

              debug-mode off
              security-policy-implementation C
              verbose-security off
              default-zpublisher-encoding utf-8
              zserver-threads ${toString opts.threads}
              effective-user ${opts.user}

              pid-filename ${opts.clientHome}/${opts.name}/pid
              lock-filename ${opts.clientHome}/${opts.name}/lock
              python-check-interval 1000
              enable-product-installation off

              <environment>
                zope_i18n_compile_mo_files false
              </environment>

              <eventlog>
              level INFO
              <logfile>
                  path /var/log/zope2/${name}.log
                  level INFO
              </logfile>
              </eventlog>

              <logger access>
              level WARN
              <logfile>
                  path /var/log/zope2/${name}-Z2.log
                  format %(message)s
              </logfile>
              </logger>

              <http-server>
              address ${opts.http_address}
              </http-server>

              <zodb_db temporary>
              <temporarystorage>
                  name temporary storage for sessioning
              </temporarystorage>
              mount-point /temp_folder
              container-class Products.TemporaryFolder.TemporaryContainer
              </zodb_db>

              ${opts.extra}
              '';
            ctlScript = pkgs.writeScript "zope2-${name}-ctl-script"
              ''
              #!${env}/bin/python

              import sys
              import plone.recipe.zope2instance.ctl

              if __name__ == '__main__':
                  sys.exit(plone.recipe.zope2instance.ctl.main(
                      ["-C", "${conf}"]
                      + sys.argv[1:]))
              '';

            ctl = pkgs.writeScript "zope2-${name}-ctl"
              ''
              #!${pkgs.bash}/bin/bash -e
              export PYTHONHOME=${env}
              exec ${ctlScript} "$@"
              '';
          in {
            #description = "${name} instance";
            after = [ "network.target" ];  # with RelStorage also add "postgresql.service"
            wantedBy = [ "multi-user.target" ];
            path = opts.packages;
            preStart =
              ''
              mkdir -p /var/log/zope2/
              touch /var/log/zope2/${name}.log
              touch /var/log/zope2/${name}-Z2.log
              chown ${opts.user} /var/log/zope2/${name}.log
              chown ${opts.user} /var/log/zope2/${name}-Z2.log

              mkdir -p ${opts.clientHome}/filestorage ${opts.clientHome}/blobstorage
              mkdir -p ${opts.clientHome}/${opts.name}
              chown ${opts.user} ${opts.clientHome} -R

              ${ctl} adduser admin admin
              '';

            serviceConfig.Type = "forking";
            serviceConfig.ExecStart = "${ctl} start";
            serviceConfig.ExecStop = "${ctl} stop";
            serviceConfig.ExecReload = "${ctl} restart";
          };

      in listToAttrs (map (name: { name = "zope2-${name}"; value = createZope2Instance (builtins.getAttr name cfg.instances) name; }) (builtins.attrNames cfg.instances));

  };

}
