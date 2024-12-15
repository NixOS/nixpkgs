import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    # See https://docs.aws.amazon.com/sdkref/latest/guide/file-format.html.
    iniFormat = pkgs.formats.ini { };

    region = "ap-northeast-1";
    sharedConfigurationDefaultProfile = "default";
    sharedConfigurationFile = iniFormat.generate "config" {
      "${sharedConfigurationDefaultProfile}" = {
        region = region;
      };
    };
    sharedCredentialsFile = iniFormat.generate "credentials" {
      "${sharedConfigurationDefaultProfile}" = {
        aws_access_key_id = "placeholder";
        aws_secret_access_key = "placeholder";
        aws_session_token = "placeholder";
      };
    };
    sharedConfigurationDirectory = pkgs.runCommand ".aws" { } ''
      mkdir $out

      cp ${sharedConfigurationFile} $out/config
      cp ${sharedCredentialsFile} $out/credentials
    '';
  in
  {
    name = "amazon-cloudwatch-agent";
    meta.maintainers = pkgs.amazon-cloudwatch-agent.meta.maintainers;

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.amazon-cloudwatch-agent = {
          enable = true;
          commonConfiguration = {
            credentials = {
              shared_credential_profile = sharedConfigurationDefaultProfile;
              shared_credential_file = "${sharedConfigurationDirectory}/credentials";
            };
          };
          configuration = {
            agent = {
              # Required despite documentation saying the agent ignores it in "onPremise" mode.
              region = region;

              # Show debug logs and write to a file for interactive debugging.
              debug = true;
              logfile = "/var/log/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log";
            };
            logs = {
              logs_collected = {
                files = {
                  collect_list = [
                    {
                      file_path = "/var/log/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log";
                      log_group_name = "/var/log/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log";
                      log_stream_name = "{local_hostname}";
                    }
                  ];
                };
              };
            };
            traces = {
              local_mode = true;
              traces_collected = {
                xray = { };
              };
            };
          };
          mode = "onPremise";
        };

        # Keep the runtime directory for interactive debugging.
        systemd.services.amazon-cloudwatch-agent.serviceConfig.RuntimeDirectoryPreserve = true;
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("amazon-cloudwatch-agent.service")

      machine.wait_for_file("/run/amazon-cloudwatch-agent/amazon-cloudwatch-agent.pid")
      machine.wait_for_file("/run/amazon-cloudwatch-agent/amazon-cloudwatch-agent.toml")
      # "config-translator" omits this file if no trace configurations are specified.
      #
      # See https://github.com/aws/amazon-cloudwatch-agent/issues/1320.
      machine.wait_for_file("/run/amazon-cloudwatch-agent/amazon-cloudwatch-agent.yaml")
      machine.wait_for_file("/run/amazon-cloudwatch-agent/env-config.json")
    '';
  }
)
