{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.garm.provision;

  format = pkgs.formats.json { };

  isSecret = v: lib.isAttrs v && lib.attrNames v == [ "_secret" ];

  # Applies f to the path of every { _secret = "/path"; } in v.
  mapSecrets =
    f: v:
    if isSecret v then
      f (toString v._secret)
    else if lib.isAttrs v then
      lib.mapAttrs (_: mapSecrets f) v
    else if lib.isList v then
      map (mapSecrets f) v
    else
      v;

  collectSecrets =
    v:
    if isSecret v then
      [ (toString v._secret) ]
    else if lib.isAttrs v then
      lib.concatMap collectSecrets (lib.attrValues v)
    else if lib.isList v then
      lib.concatMap collectSecrets v
    else
      [ ];

  secretPaths = lib.unique (collectSecrets cfg.settings);

  # The hash keeps files of the same name in different directories apart.
  # The name is only there for whoever reads the unit.
  credentialName =
    path:
    "${
      lib.substring 0 8 (builtins.hashString "sha256" path)
    }-${lib.strings.sanitizeDerivationName (baseNameOf path)}";

  # Secrets are passed as systemd credentials, which garm-reconcile finds by
  # their name. This way the files only need to be readable by root.
  stateFile = format.generate "garm-state.json" (
    mapSecrets (path: { _secret = credentialName path; }) cfg.settings
  );

  checkedStateFile = pkgs.runCommand "garm-state.json" { nativeBuildInputs = [ cfg.package ]; } ''
    garm-reconcile validate ${stateFile}
    cp ${stateFile} $out
  '';
in

{
  options.services.garm.provision = {
    enable = lib.mkEnableOption "declarative configuration of GARM with garm-reconcile";

    package = lib.mkPackageOption pkgs "garm-reconcile" { };

    url = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:${toString config.services.garm.settings.apiserver.port}";
      defaultText = lib.literalExpression ''"http://127.0.0.1:''${toString config.services.garm.settings.apiserver.port}"'';
      description = ''
        Base URL of the GARM API. The default is the instance that
        {option}`services.garm.enable` runs on this machine.
      '';
    };

    prune = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to delete resources that don't match the configuration. Pools and scale sets are
        deleted once the jobs on their runners finished.
      '';
    };

    drainTimeout = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "6h";
      description = ''
        How long deleting pools and scale sets waits for the jobs on their
        runners, as a Go duration. The service fails when the time is up and
        continues when it is started again. By default it waits until the
        jobs finished.
      '';
    };

    settings = lib.mkOption {
      type = format.type;
      example = lib.literalExpression ''
        {
          admin = {
            username = "admin";
            email = "admin@example.com";
            password._secret = "/run/keys/garm-admin-password";
          };
          controller = {
            metadata_url = "http://10.0.10.1:9997/api/v1/metadata";
            callback_url = "http://10.0.10.1:9997/api/v1/callbacks";
            agent_url = "http://10.0.10.1:9997/agent";
            webhook_url = "http://10.0.10.1:9997/webhooks";
          };
          github = {
            credentials.cred1 = {
              endpoint = "github.com";
              pat.oauth2_token._secret = "/run/keys/github-token";
            };
            repositories."owner/name" = {
              credentials_name = "cred1";
              pools.linux = {
                provider_name = "incus";
                image = "images:ubuntu/24.04/cloud";
                flavor = "default";
                os_type = "linux";
                os_arch = "amd64";
                tags = [ "self-hosted" ];
                max_runners = 2;
                enabled = true;
              };
            };
          };
        }
      '';
      description = ''
        The desired state of GARM: its admin user, the URLs of the controller,
        and the endpoints, credentials, templates, repositories,
        organizations and enterprises with their pools and scale sets. See
        <https://github.com/katexochen/garm-reconcile> for the available
        settings. The state is checked when the system is built.

        Any string can be given as `{ _secret = "/path/to/file"; }`, and is
        then read from that file when the state is applied. The files are
        loaded through systemd credentials, so they only need to be readable
        by root.
      '';
    };

    stateFile = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      internal = true;
      default = checkedStateFile;
      description = "The checked desired state the service applies.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.garm-provision = {
      description = "Declarative configuration of GARM";
      wantedBy = [ "multi-user.target" ];
      requires = lib.optional config.services.garm.enable "garm.service";
      after = lib.optional config.services.garm.enable "garm.service";
      serviceConfig = {
        # The service is started once everything declared is in place.
        # Deleting the rest waits for running jobs and continues in the
        # background.
        Type = "notify";
        RemainAfterExit = true;
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "apply"
            "-url"
            cfg.url
          ]
          ++ lib.optional cfg.prune "-prune"
          ++ lib.optionals (cfg.drainTimeout != null) [
            "-drain-timeout"
            cfg.drainTimeout
          ]
          ++ [ "${cfg.stateFile}" ]
        );
        LoadCredential = map (
          path: "${credentialName path}:${lib.replaceStrings [ "%" ] [ "%%" ] path}"
        ) secretPaths;
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "10s";
        # 3 means garm has another admin user, which a restart can't change.
        RestartPreventExitStatus = 3;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ katexochen ];
}
