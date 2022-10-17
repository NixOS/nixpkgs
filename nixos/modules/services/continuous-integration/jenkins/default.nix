{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.jenkins;
  jenkinsUrl = "http://${cfg.listenAddress}:${toString cfg.port}${cfg.prefix}";
in {
  options = {
    services.jenkins = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the jenkins continuous integration server.
        '';
      };

      user = mkOption {
        default = "jenkins";
        type = types.str;
        description = lib.mdDoc ''
          User the jenkins server should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins";
        type = types.str;
        description = lib.mdDoc ''
          If the default user "jenkins" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" "dialout" ];
        description = lib.mdDoc ''
          List of extra groups that the "jenkins" user should be a part of.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins";
        type = types.path;
        description = lib.mdDoc ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      listenAddress = mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = types.str;
        description = lib.mdDoc ''
          Specifies the bind address on which the jenkins HTTP interface listens.
          The default is the wildcard address.
        '';
      };

      port = mkOption {
        default = 8080;
        type = types.port;
        description = lib.mdDoc ''
          Specifies port number on which the jenkins HTTP interface listens.
          The default is 8080.
        '';
      };

      prefix = mkOption {
        default = "";
        example = "/jenkins";
        type = types.str;
        description = lib.mdDoc ''
          Specifies a urlPrefix to use with jenkins.
          If the example /jenkins is given, the jenkins server will be
          accessible using localhost:8080/jenkins.
        '';
      };

      package = mkOption {
        default = pkgs.jenkins;
        defaultText = literalExpression "pkgs.jenkins";
        type = types.package;
        description = lib.mdDoc "Jenkins package to use.";
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.git pkgs.jdk11 config.programs.ssh.package pkgs.nix ];
        defaultText = literalExpression "[ pkgs.stdenv pkgs.git pkgs.jdk11 config.programs.ssh.package pkgs.nix ]";
        type = types.listOf types.package;
        description = lib.mdDoc ''
          Packages to add to PATH for the jenkins process.
        '';
      };

      environment = mkOption {
        default = { };
        type = with types; attrsOf str;
        description = lib.mdDoc ''
          Additional environment variables to be passed to the jenkins process.
          As a base environment, jenkins receives NIX_PATH from
          {option}`environment.sessionVariables`, NIX_REMOTE is set to
          "daemon" and JENKINS_HOME is set to the value of
          {option}`services.jenkins.home`.
          This option has precedence and can be used to override those
          mentioned variables.
        '';
      };

      plugins = mkOption {
        default = null;
        type = types.nullOr (types.attrsOf types.package);
        description = lib.mdDoc ''
          A set of plugins to activate. Note that this will completely
          remove and replace any previously installed plugins. If you
          have manually-installed plugins that you want to keep while
          using this module, set this option to
          `null`. You can generate this set with a
          tool such as `jenkinsPlugins2nix`.
        '';
        example = literalExpression ''
          import path/to/jenkinsPlugins2nix-generated-plugins.nix { inherit (pkgs) fetchurl stdenv; }
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--debug=9" ];
        description = lib.mdDoc ''
          Additional command line arguments to pass to Jenkins.
        '';
      };

      extraJavaOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-Xmx80m" ];
        description = lib.mdDoc ''
          Additional command line arguments to pass to the Java run time (as opposed to Jenkins).
        '';
      };

      withCLI = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to make the CLI available.

          More info about the CLI available at
          [
          https://www.jenkins.io/doc/book/managing/cli](https://www.jenkins.io/doc/book/managing/cli) .
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      # server references the dejavu fonts
      systemPackages = [
        pkgs.dejavu_fonts
      ] ++ optional cfg.withCLI cfg.package;

      variables = {}
        // optionalAttrs cfg.withCLI {
          # Make it more convenient to use the `jenkins-cli`.
          JENKINS_URL = jenkinsUrl;
        };
    };

    users.groups = optionalAttrs (cfg.group == "jenkins") {
      jenkins.gid = config.ids.gids.jenkins;
    };

    users.users = optionalAttrs (cfg.user == "jenkins") {
      jenkins = {
        description = "jenkins user";
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
        uid = config.ids.uids.jenkins;
      };
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
              if cfg.plugins == null
              then ""
              else
                let pluginCmds = lib.attrsets.mapAttrsToList
                      (n: v: "cp ${v} ${cfg.home}/plugins/${n}.jpi")
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

      # For reference: https://wiki.jenkins.io/display/JENKINS/JenkinsLinuxStartupScript
      script = ''
        ${pkgs.jdk11}/bin/java ${concatStringsSep " " cfg.extraJavaOptions} -jar ${cfg.package}/webapps/jenkins.war --httpListenAddress=${cfg.listenAddress} \
                                                  --httpPort=${toString cfg.port} \
                                                  --prefix=${cfg.prefix} \
                                                  -Djava.awt.headless=true \
                                                  ${concatStringsSep " " cfg.extraOptions}
      '';

      postStart = ''
        until [[ $(${pkgs.curl.bin}/bin/curl -L -s --head -w '\n%{http_code}' ${jenkinsUrl} | tail -n1) =~ ^(200|403)$ ]]; do
          sleep 1
        done
      '';

      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
