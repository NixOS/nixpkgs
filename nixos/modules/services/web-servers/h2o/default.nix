{
  config,
  lib,
  pkgs,
  ...
}:

# TODO: Gems includes for Mruby
# TODO: Recommended options
let
  cfg = config.services.h2o;
  inherit (config.security.acme) certs;

  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  mkCertOwnershipAssertion = import ../../../security/acme/mk-cert-ownership-assertion.nix lib;

  settingsFormat = pkgs.formats.yaml { };

  getNames = name: vhostSettings: rec {
    server = if vhostSettings.serverName != null then vhostSettings.serverName else name;
    cert =
      if lib.attrByPath [ "acme" "useHost" ] null vhostSettings == null then
        server
      else
        vhostSettings.acme.useHost;
  };

  # Attrset with the virtual hosts relevant to ACME configuration
  acmeEnabledHostsConfigs = lib.foldlAttrs (
    acc: name: value:
    if value.acme == null || (!value.acme.enable && value.acme.useHost == null) then
      acc
    else
      let
        names = getNames name value;
        virtualHostConfig = value // {
          serverName = names.server;
          certName = names.cert;
        };
      in
      acc ++ [ virtualHostConfig ]
  ) [ ] cfg.hosts;

  # Attrset with the ACME certificate names split by whether or not they depend
  # on H2O serving challenges.
  certNames =
    let
      partition =
        acc: vhostSettings:
        let
          inherit (vhostSettings) certName;
          isDependent = certs.${certName}.dnsProvider == null;
        in
        if isDependent && !(builtins.elem certName acc.dependent) then
          acc // { dependent = acc.dependent ++ [ certName ]; }
        else if !isDependent && !(builtins.elem certName acc.independent) then
          acc // { independent = acc.independent ++ [ certName ]; }
        else
          acc;

      certNames' = lib.lists.foldl partition {
        dependent = [ ];
        independent = [ ];
      } acmeEnabledHostsConfigs;
    in
    certNames'
    // {
      all = certNames'.dependent ++ certNames'.independent;
    };

  hostsConfig = lib.concatMapAttrs (
    name: value:
    let
      port = {
        HTTP = lib.attrByPath [ "http" "port" ] cfg.defaultHTTPListenPort value;
        TLS = lib.attrByPath [ "tls" "port" ] cfg.defaultTLSListenPort value;
      };

      names = getNames name value;

      acmeSettings = lib.optionalAttrs (builtins.elem names.cert certNames.dependent) (
        let
          acmePort = 80;
          acmeChallengePath = "/.well-known/acme-challenge";
        in
        {
          "${names.server}:${builtins.toString acmePort}" = {
            listen.port = acmePort;
            paths."${acmeChallengePath}/" = {
              "file.dir" = value.acme.root + acmeChallengePath;
            };
          };
        }
      );

      httpSettings =
        lib.optionalAttrs (value.tls == null || value.tls.policy == "add") {
          "${names.server}:${builtins.toString port.HTTP}" = value.settings // {
            listen.port = port.HTTP;
          };
        }
        // lib.optionalAttrs (value.tls != null && value.tls.policy == "force") {
          "${names.server}:${builtins.toString port.HTTP}" = {
            listen.port = port.HTTP;
            paths."/" = {
              redirect = {
                status = value.tls.redirectCode;
                url = "https://${names.server}:${builtins.toString port.TLS}";
              };
            };
          };
        };

      tlsSettings =
        lib.optionalAttrs
          (
            value.tls != null
            && builtins.elem value.tls.policy [
              "add"
              "only"
              "force"
            ]
          )
          {
            "${names.server}:${builtins.toString port.TLS}" = value.settings // {
              listen =
                let
                  identity =
                    value.tls.identity
                    ++ lib.optional (builtins.elem names.cert certNames.all) {
                      key-file = "${certs.${names.cert}.directory}/key.pem";
                      certificate-file = "${certs.${names.cert}.directory}/fullchain.pem";
                    };
                in
                {
                  port = port.TLS;
                  ssl = value.tls.extraSettings // {
                    inherit identity;
                  };
                };
            };
          };
    in
    # With a high likelihood of HTTP & ACME challenges being on the same port,
    # 80, do a recursive update to merge the 2 settings together
    (lib.recursiveUpdate acmeSettings httpSettings) // tlsSettings
  ) cfg.hosts;

  h2oConfig = settingsFormat.generate "h2o.yaml" (
    lib.recursiveUpdate { hosts = hostsConfig; } cfg.settings
  );

  # Executing H2O with our generated configuration; `mode` added as needed
  h2oExe = ''${lib.getExe cfg.package} ${
    lib.strings.escapeShellArgs [
      "--conf"
      "${h2oConfig}"
    ]
  }'';
in
{
  options = {
    services.h2o = {
      enable = mkEnableOption "H2O web server";

      user = mkOption {
        type = types.nonEmptyStr;
        default = "h2o";
        description = "User running H2O service";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "h2o";
        description = "Group running H2O services";
      };

      package = lib.mkPackageOption pkgs "h2o" {
        example = ''
          pkgs.h2o.override {
            withMruby = false;
          };
        '';
      };

      defaultHTTPListenPort = mkOption {
        type = types.port;
        default = 80;
        description = ''
          If hosts do not specify listen.port, use these ports for HTTP by default.
        '';
        example = 8080;
      };

      defaultTLSListenPort = mkOption {
        type = types.port;
        default = 443;
        description = ''
          If hosts do not specify listen.port, use these ports for SSL by default.
        '';
        example = 8443;
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = "Configuration for H2O (see <https://h2o.examp1e.net/configure.html>)";
      };

      hosts = mkOption {
        type = types.attrsOf (
          types.submodule (
            import ./vhost-options.nix {
              inherit config lib;
            }
          )
        );
        default = { };
        description = ''
          The `hosts` config to be merged with the settings.

          Note that unlike YAML used for H2O, Nix will not support duplicate
          keys to, for instance, have multiple listens in a host block; use the
          virtual host options in like `http` & `tls` or use `$HOST:$PORT`
          keys if manually specifying config.
        '';
        example =
          literalExpression
            # nix
            ''
              {
                "hydra.example.com" = {
                  tls = {
                    policy = "force";
                    indentity = [
                      {
                        key-file = "/path/to/key";
                        certificate-file = "/path/to/cert";
                      };
                    ];
                    extraSettings = {
                      minimum-version = "TLSv1.3";
                    };
                  };
                  settings = {
                    paths."/" = {
                      "file:dir" = "/var/www/default";
                    };
                  };
                };
              }
            '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [
        {
          assertion =
            !(builtins.hasAttr "hosts" h2oConfig)
            || builtins.all (
              host:
              let
                hasKeyPlusCert = attrs: (attrs.key-file or "") != "" && (attrs.certificate-file or "") != "";
              in
              # TLS not used
              (lib.attrByPath [ "listen" "ssl" ] null host == null)
              # TLS identity property
              || (
                builtins.hasAttr "identity" host
                && builtins.length host.identity > 0
                && builtins.all hasKeyPlusCert host.listen.ssl.identity
              )
              # TLS short-hand (was manually specified)
              || (hasKeyPlusCert host.listen.ssl)
            ) (lib.attrValues h2oConfig.hosts);
          message = ''
            TLS support will require at least one non-empty certificate & key
            file. Use services.h2o.hosts.<name>.acme.enable,
            services.h2o.hosts.<name>.acme.useHost,
            services.h2o.hosts.<name>.tls.identity, or
            services.h2o.hosts.<name>.tls.extraSettings.
          '';
        }
      ]
      ++ builtins.map (
        name:
        mkCertOwnershipAssertion {
          cert = certs.${name};
          groups = config.users.groups;
          services = [
            config.systemd.services.h2o
          ] ++ lib.optional (certNames.all != [ ]) config.systemd.services.h2o-config-reload;
        }
      ) certNames.all;

    users = {
      users.${cfg.user} =
        {
          group = cfg.group;
        }
        // lib.optionalAttrs (cfg.user == "h2o") {
          isSystemUser = true;
        };
      groups.${cfg.group} = { };
    };

    systemd.services.h2o = {
      description = "H2O HTTP server";
      wantedBy = [ "multi-user.target" ];
      wants = lib.concatLists (map (certName: [ "acme-finished-${certName}.target" ]) certNames.all);
      # Since H2O will be hosting the challenges, H2O must be started
      before = builtins.map (certName: "acme-${certName}.service") certNames.dependent;
      after =
        [ "network.target" ]
        ++ builtins.map (certName: "acme-selfsigned-${certName}.service") certNames.all
        ++ builtins.map (certName: "acme-${certName}.service") certNames.independent; # avoid loading self-signed key w/ real cert, or vice-versa

      serviceConfig = {
        ExecStart = "${h2oExe} --mode 'master'";
        ExecReload = [
          "${h2oExe} --mode 'test'"
          "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
        ];
        ExecStop = "${pkgs.coreutils}/bin/kill -s QUIT $MAINPID";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "10s";
        RuntimeDirectory = "h2o";
        RuntimeDirectoryMode = "0750";
        CacheDirectory = "h2o";
        CacheDirectoryMode = "0750";
        LogsDirectory = "h2o";
        LogsDirectoryMode = "0750";
        ProtectSystem = "strict";
        ProtectHome = mkDefault true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilitiesBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };

      preStart = "${h2oExe} --mode 'test'";
    };

    # This service waits for all certificates to be available before reloading
    # H2O configuration. `tlsTargets` are added to `wantedBy` + `before` which
    # allows the `acme-finished-$cert.target` to signify the successful updating
    # of certs end-to-end.
    systemd.services.h2o-config-reload =
      let
        tlsTargets = map (certName: "acme-${certName}.target") certNames.all;
        tlsServices = map (certName: "acme-${certName}.service") certNames.all;
      in
      mkIf (certNames.all != [ ]) {
        wantedBy = tlsServices ++ [ "multi-user.target" ];
        before = tlsTargets;
        after = tlsServices;
        unitConfig = {
          ConditionPathExists = map (certName: "${certs.${certName}.directory}/fullchain.pem") certNames.all;
          # Disable rate limiting for this since it may be triggered quickly
          # a bunch of times if a lot of certificates are renewed in quick
          # succession. The reload itself is cheap, so even doing a lot of them
          # in a short burst is fine.
          #
          # FIXME: like Nginx’s FIXME, there’s probably a better way to do
          # this.
          StartLimitIntervalSec = 0;
        };
        serviceConfig = {
          Type = "oneshot";
          TimeoutSec = 60;
          ExecCondition = "/run/current-system/systemd/bin/systemctl -q is-active h2o.service";
          ExecStart = "/run/current-system/systemd/bin/systemctl reload h2o.service";
        };
      };

    security.acme.certs =
      let
        mkCerts =
          acc: vhostSettings:
          if vhostSettings.acme.useHost == null then
            let
              hasRoot = vhostSettings.acme.root != null;
            in
            acc
            // {
              "${vhostSettings.serverName}" = {
                group = mkDefault cfg.group;
                # If `acme.root` is `null`, inherit `config.security.acme`.
                # Since `config.security.acme.certs.<cert>.webroot`’s own
                # default value should take precedence set priority higher than
                # mkOptionDefault
                webroot = lib.mkOverride (if hasRoot then 1000 else 2000) vhostSettings.acme.root;
                # Also nudge dnsProvider to null in case it is inherited
                dnsProvider = lib.mkOverride (if hasRoot then 1000 else 2000) null;
                extraDomainNames = vhostSettings.serverAliases;
              };
            }
          else
            acc;
      in
      lib.lists.foldl mkCerts { } acmeEnabledHostsConfigs;
  };
}
