{ config, lib, pkgs, ... }:

with lib;

let
  jenkinsCfg = config.services.jenkins;
  cfg = config.services.jenkins.credentials;

  _credentialsType = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        example = "my-credentials-id";
        description = ''
          The internal unique ID by which the credentials to create will be identified from jobs and other configuration.
        '';
      };
      username = mkOption {
        type = types.str;
        example = "pamplemousse";
        description = ''
          The username part of the credentials to create.
        '';
      };
      password = mkOption {
        type = types.str;
        example = "";
        description = ''
          The password part of the credentials to create.
        '';
      };
      description = mkOption {
        type = types.str;
        default = "";
        example = "My new credentials.";
        description = ''
          The descriptive text associated with the credentials to create.
        '';
      };
    };
  };
in
{
  options = {
    services.jenkins.credentials = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable declarative management of Jenkins' credentials.

          Credentials managed through the Jenkins WebUI (or by other means) are left unchanged.

          Note that it really is declarative configuration;
          if you remove a previously defined credentials, the corresponding credentials will be deleted.

          Please see the Jenkins Credentials plugin documentation for more info:
          <link xlink:href="https://plugins.jenkins.io/credentials">
          https://plugins.jenkins.io/credentials</link>
        '';
      };

      accessUser = mkOption {
        default = "";
        type = types.str;
        description = ''
          User id in Jenkins used to reload config.
        '';
      };

      accessToken = mkOption {
        default = "";
        type = types.str;
        description = ''
          User token in Jenkins used to reload config.
          WARNING: This token will be world readable in the Nix store. To keep
          it secret, use the <option>accessTokenFile</option> option instead.
        '';
      };

      accessTokenFile = mkOption {
        default = "";
        type = types.str;
        example = "/run/keys/jenkins-credentials-access-token";
        description = ''
          File containing the API token for the <option>accessUser</option>
          user.
        '';
      };

      credentials = mkOption {
        default = [];
        type = types.listOf _credentialsType;
        description = ''
          The list of credentials to create.
        '';
      };
    };
  };

  config = mkIf (jenkinsCfg.enable && cfg.enable) {
    assertions = [
      { assertion = jenkinsCfg.withCLI;
        message = ''
          The jenkins CLI is required for declarative credentials management.
          Current value:
            services.jenkins.withCli = "${jenkinsCfg.withCLI}"
        '';
      }
      { assertion =
          if cfg.accessUser != ""
          then (cfg.accessToken != "" && cfg.accessTokenFile == "") ||
               (cfg.accessToken == "" && cfg.accessTokenFile != "")
          else true;
        message = ''
          One of accessToken and accessTokenFile options must be non-empty
          strings, but not both. Current values:
            services.jenkins.credentials.accessToken = "${cfg.accessToken}"
            services.jenkins.credentials.accessTokenFile = "${cfg.accessTokenFile}"
        '';
      }
    ];

    systemd.services.jenkins-credentials = {
      description = "Jenkins Credentials Management";
      after = [ "jenkins.service" ];
      wantedBy = [ "multi-user.target" ];

      # Make the commands `jenkins-cli` and `xmllint` available.
      path = with pkgs; [ jenkins libxml2 ];

      # Implicit URL parameter for `jenkins-cli`.
      environment = {
        JENKINS_URL =
          "http://${jenkinsCfg.listenAddress}:${toString jenkinsCfg.port}${jenkinsCfg.prefix}";
      };

      script =
        let
          _jenkinsCLI = {
            auth = "-auth admin:\"$(cat ${jenkinsCfg.home}/secrets/initialAdminPassword)\"";
            domain = "\"(global)\"";
            user = "system::system::jenkins";
          };

          # Arguments passed to this functions are of `_credentialsType`.
          _credentialsXMLData = credentials: with credentials; ''
              <com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl plugin="credentials@2.1.14">
                <scope>GLOBAL</scope>
                <id>${id}</id>
                <description>${description}</description>
                <username>${username}</username>
                <password>${password}</password>
              </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>'';

          _currentlyDeclaredCredentials = "/run/jenkins-credentials/declarative-credentials";
        in
        ''
          # For truly declarative management of credentials, we follow:
          #   - Any declared credentials will have an associated file: `~/credentials/<ID of the credentials>/credentials.xml`;
          #   - `${_currentlyDeclaredCredentials}` will have one currently declared credentials' ID per line;
          #   - `existingCredentialsIDs` is the list of credentials that are actually registered in Jenkins;
          #   - Declared credentials not in this list are created, the one that are are updated;
          #   - Credentials that are present in `~/credentials/` but not currently declared are removed.

          if [ -f "${_currentlyDeclaredCredentials}" ]; then
            rm ${_currentlyDeclaredCredentials}
          fi
          touch ${_currentlyDeclaredCredentials}

          generatedCredentialsDir="${jenkinsCfg.home}/credentials"

          #
          # Generate data files for all declared credentials
          #
          echo "Generating files for declared credentials"

          ${lib.concatMapStringsSep "\n" (x:
          ''
          credentialsID="${x.id}"
          credentialsDir="$generatedCredentialsDir/$credentialsID"
          echo -e "\tGenerating file for \"$credentialsID\""
          mkdir -p "$credentialsDir"

          cat << __EOF__ > "$credentialsDir/credentials.xml"
          ${_credentialsXMLData x}
          __EOF__

          echo "$credentialsID" >> ${_currentlyDeclaredCredentials}
          ''
          ) cfg.credentials}

          #
          # Create new credentials
          # Update existing credentials
          #
          existingCredentialsIDs="$(jenkins-cli ${_jenkinsCLI.auth} list-credentials-as-xml ${_jenkinsCLI.user} | xmllint --xpath '//credentials//id/text()' -)"

          echo "Updating existing credentials"

          for credentialsID in $existingCredentialsIDs; do
            file="$generatedCredentialsDir/$credentialsID/credentials.xml"

            if [ -f "$file" ]; then
              echo -e "\tUpdating credentials \"$credentialsID\""
              jenkins-cli ${_jenkinsCLI.auth} update-credentials-by-xml ${_jenkinsCLI.user} ${_jenkinsCLI.domain} "$credentialsID" < "$file"
            fi
          done

          echo "Creating new credentials"

          for credentialsID in $(cat ${_currentlyDeclaredCredentials}); do
            if ! echo $existingCredentialsIDs | grep --quiet $credentialsID; then
              echo -e "\tCreating credentials \"$credentialsID\""

              file="$generatedCredentialsDir/$credentialsID/credentials.xml"
              jenkins-cli ${_jenkinsCLI.auth} create-credentials-by-xml ${_jenkinsCLI.user} ${_jenkinsCLI.domain} < "$file"
            fi
          done

          #
          # Remove stale credentials
          #
          echo "Removing stale credentials"

          for file in "$generatedCredentialsDir"/*/credentials.xml; do
              credentialsIDFolder="$(dirname "$file")"
              credentialsID="$(basename "$credentialsIDFolder")"

              # Don't remove it is from the latest declaration.
              grep --quiet --line-regexp "$credentialsID" ${_currentlyDeclaredCredentials} 2>/dev/null && continue

              echo -e "\tRemoving credentials \"$credentialsID\""

              jenkins-cli ${_jenkinsCLI.auth} delete-credentials ${_jenkinsCLI.user} ${_jenkinsCLI.domain} "$credentialsID"

              rm -R "$credentialsIDFolder"
          done
        '';

      serviceConfig = {
        User = jenkinsCfg.user;
        RuntimeDirectory = "jenkins-credentials";
      };
    };
  };
}
