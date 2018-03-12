{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.jenkins;
in {
  options = {
    services.jenkins = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the jenkins continuous integration server.
        '';
      };

      user = mkOption {
        default = "jenkins";
        type = types.str;
        description = ''
          User the jenkins server should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins";
        type = types.str;
        description = ''
          If the default user "jenkins" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" "dialout" ];
        description = ''
          List of extra groups that the "jenkins" user should be a part of.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = types.path;
        description = ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      listenAddress = mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = types.str;
        description = ''
          Specifies the bind address on which the jenkins HTTP interface listens.
          The default is the wildcard address.
        '';
      };

      port = mkOption {
        default = 8080;
        type = types.int;
        description = ''
          Specifies port number on which the jenkins HTTP interface listens.
          The default is 8080.
        '';
      };

      prefix = mkOption {
        default = "";
        example = "/jenkins";
        type = types.str;
        description = ''
          Specifies a urlPrefix to use with jenkins.
          If the example /jenkins is given, the jenkins server will be
          accessible using localhost:8080/jenkins.
        '';
      };

      package = mkOption {
        default = pkgs.jenkins;
        defaultText = "pkgs.jenkins";
        type = types.package;
        description = "Jenkins package to use.";
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.git pkgs.jdk config.programs.ssh.package pkgs.nix ];
        defaultText = "[ pkgs.stdenv pkgs.git pkgs.jdk config.programs.ssh.package pkgs.nix ]";
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the jenkins process.
        '';
      };

      environment = mkOption {
        default = { };
        type = with types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the jenkins process.
          As a base environment, jenkins receives NIX_PATH from
          <option>environment.sessionVariables</option>, NIX_REMOTE is set to
          "daemon" and JENKINS_HOME is set to the value of
          <option>services.jenkins.home</option>.
          This option has precedence and can be used to override those
          mentioned variables.
        '';
      };

      plugins = mkOption {
        default = null;
        type = types.nullOr (types.attrsOf types.package);
        description = ''
          A set of plugins to activate. Note that this will completely
          remove and replace any previously installed plugins. If you
          have manually-installed plugins that you want to keep while
          using this module, set this option to
          <literal>null</literal>. You can generate this set with a
          tool such as <literal>jenkinsPlugins2nix</literal>.
        '';
        example = literalExample ''
          import path/to/jenkinsPlugins2nix-generated-plugins.nix { inherit (pkgs) fetchurl stdenv; }
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--debug=9" ];
        description = ''
          Additional command line arguments to pass to Jenkins.
        '';
      };

      extraJavaOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-Xmx80m" ];
        description = ''
          Additional command line arguments to pass to the Java run time (as opposed to Jenkins).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "jenkins") {
      name = "jenkins";
      gid = config.ids.gids.jenkins;
    };

    users.extraUsers = optional (cfg.user == "jenkins") {
      name = "jenkins";
      description = "jenkins user";
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
      uid = config.ids.uids.jenkins;
    };

    systemd.services.jenkins = {
      description = "Jenkins Continuous Integration Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        let
          selectedSessionVars =
            lib.filterAttrs (n: v: builtins.elem n [ "NIX_PATH" ])
              config.environment.sessionVariables;
        in
          selectedSessionVars //
          { JENKINS_HOME = cfg.home;
            NIX_REMOTE = "daemon";
          } //
          cfg.environment;

      path = cfg.packages;

      # Force .war (re)extraction, or else we might run stale Jenkins.

      preStart =
        let replacePlugins =
              if isNull cfg.plugins
              then ""
              else
                let pluginCmds = lib.attrsets.mapAttrsToList
                      (n: v: "cp ${v} ${cfg.home}/plugins/${n}.hpi")
                      cfg.plugins;
                in ''
                  rm -r ${cfg.home}/plugins || true
                  mkdir -p ${cfg.home}/plugins
                  ${lib.strings.concatStringsSep "\n" pluginCmds}
                '';
        in ''
          rm -rf ${cfg.home}/war
          ${replacePlugins}
        '';

      script = ''
        ${pkgs.jdk}/bin/java ${concatStringsSep " " cfg.extraJavaOptions} -jar ${cfg.package}/webapps/jenkins.war --httpListenAddress=${cfg.listenAddress} \
                                                  --httpPort=${toString cfg.port} \
                                                  --prefix=${cfg.prefix} \
                                                  ${concatStringsSep " " cfg.extraOptions}
      '';

      postStart = ''
        until [[ $(${pkgs.curl.bin}/bin/curl -L -s --head -w '\n%{http_code}' http://${cfg.listenAddress}:${toString cfg.port}${cfg.prefix} | tail -n1) =~ ^(200|403)$ ]]; do
          sleep 1
        done
      '';

      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
