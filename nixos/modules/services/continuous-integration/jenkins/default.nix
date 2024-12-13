{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.jenkins;
  jenkinsUrl = "http://${cfg.listenAddress}:${toString cfg.port}${cfg.prefix}";
in
{
  options = {
    services.jenkins = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the jenkins continuous integration server.
        '';
      };

      user = lib.mkOption {
        default = "jenkins";
        type = lib.types.str;
        description = ''
          User the jenkins server should execute under.
        '';
      };

      group = lib.mkOption {
        default = "jenkins";
        type = lib.types.str;
        description = ''
          If the default user "jenkins" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "wheel"
          "dialout"
        ];
        description = ''
          List of extra groups that the "jenkins" user should be a part of.
        '';
      };

      home = lib.mkOption {
        default = "/var/lib/jenkins";
        type = lib.types.path;
        description = ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      listenAddress = lib.mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = lib.types.str;
        description = ''
          Specifies the bind address on which the jenkins HTTP interface listens.
          The default is the wildcard address.
        '';
      };

      port = lib.mkOption {
        default = 8080;
        type = lib.types.port;
        description = ''
          Specifies port number on which the jenkins HTTP interface listens.
          The default is 8080.
        '';
      };

      prefix = lib.mkOption {
        default = "";
        example = "/jenkins";
        type = lib.types.str;
        description = ''
          Specifies a urlPrefix to use with jenkins.
          If the example /jenkins is given, the jenkins server will be
          accessible using localhost:8080/jenkins.
        '';
      };

      package = lib.mkPackageOption pkgs "jenkins" { };

      packages = lib.mkOption {
        default = [
          pkgs.stdenv
          pkgs.git
          pkgs.jdk17
          config.programs.ssh.package
          pkgs.nix
        ];
        defaultText = lib.literalExpression "[ pkgs.stdenv pkgs.git pkgs.jdk17 config.programs.ssh.package pkgs.nix ]";
        type = lib.types.listOf lib.types.package;
        description = ''
          Packages to add to PATH for the jenkins process.
        '';
      };

      environment = lib.mkOption {
        default = { };
        type = with lib.types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the jenkins process.
          As a base environment, jenkins receives NIX_PATH from
          {option}`environment.sessionVariables`, NIX_REMOTE is set to
          "daemon" and JENKINS_HOME is set to the value of
          {option}`services.jenkins.home`.
          This option has precedence and can be used to override those
          mentioned variables.
        '';
      };

      plugins = lib.mkOption {
        default = null;
        type = lib.types.nullOr (lib.types.attrsOf lib.types.package);
        description = ''
          A set of plugins to activate. Note that this will completely
          remove and replace any previously installed plugins. If you
          have manually-installed plugins that you want to keep while
          using this module, set this option to
          `null`. You can generate this set with a
          tool such as `jenkinsPlugins2nix`.
        '';
        example = lib.literalExpression ''
          import path/to/jenkinsPlugins2nix-generated-plugins.nix { inherit (pkgs) fetchurl stdenv; }
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--debug=9" ];
        description = ''
          Additional command line arguments to pass to Jenkins.
        '';
      };

      extraJavaOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "-Xmx80m" ];
        description = ''
          Additional command line arguments to pass to the Java run time (as opposed to Jenkins).
        '';
      };

      withCLI = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to make the CLI available.

          More info about the CLI available at
          [
          https://www.jenkins.io/doc/book/managing/cli](https://www.jenkins.io/doc/book/managing/cli) .
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      # server references the dejavu fonts
      systemPackages = [
        pkgs.dejavu_fonts
      ] ++ lib.optional cfg.withCLI cfg.package;

      variables =
        { }
        // lib.optionalAttrs cfg.withCLI {
          # Make it more convenient to use the `jenkins-cli`.
          JENKINS_URL = jenkinsUrl;
        };
    };

    users.groups = lib.optionalAttrs (cfg.group == "jenkins") {
      jenkins.gid = config.ids.gids.jenkins;
    };

    users.users = lib.optionalAttrs (cfg.user == "jenkins") {
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
          selectedSessionVars = lib.filterAttrs (
            n: v: builtins.elem n [ "NIX_PATH" ]
          ) config.environment.sessionVariables;
        in
        selectedSessionVars
        // {
          JENKINS_HOME = cfg.home;
          NIX_REMOTE = "daemon";
        }
        // cfg.environment;

      path = cfg.packages;

      # Force .war (re)extraction, or else we might run stale Jenkins.

      preStart =
        let
          replacePlugins = lib.optionalString (cfg.plugins != null) (
            let
              pluginCmds = lib.mapAttrsToList (n: v: "cp ${v} ${cfg.home}/plugins/${n}.jpi") cfg.plugins;
            in
            ''
              rm -r ${cfg.home}/plugins || true
              mkdir -p ${cfg.home}/plugins
              ${lib.concatStringsSep "\n" pluginCmds}
            ''
          );
        in
        ''
          rm -rf ${cfg.home}/war
          ${replacePlugins}
        '';

      # For reference: https://wiki.jenkins.io/display/JENKINS/JenkinsLinuxStartupScript
      script = ''
        ${pkgs.jdk17}/bin/java ${lib.concatStringsSep " " cfg.extraJavaOptions} -jar ${cfg.package}/webapps/jenkins.war --httpListenAddress=${cfg.listenAddress} \
                                                  --httpPort=${toString cfg.port} \
                                                  --prefix=${cfg.prefix} \
                                                  -Djava.awt.headless=true \
                                                  ${lib.concatStringsSep " " cfg.extraOptions}
      '';

      postStart = ''
        until [[ $(${pkgs.curl.bin}/bin/curl -L -s --head -w '\n%{http_code}' ${jenkinsUrl} | tail -n1) =~ ^(200|403)$ ]]; do
          sleep 1
        done
      '';

      serviceConfig = {
        User = cfg.user;
        StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/jenkins" cfg.home) "jenkins";
        # For (possible) socket use
        RuntimeDirectory = "jenkins";
      };
    };
  };
}
