import ../../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    inherit (lib) mkMerge nameValuePair maintainers;

    baseGrafanaConf = {
      services.grafana = {
        enable = true;
        provision.enable = true;
        settings = {
          analytics.reporting_enabled = false;

          server = {
            http_addr = "localhost";
            domain = "localhost";
          };

          security = {
            admin_user = "testadmin";
            admin_password = "$__file{${pkgs.writeText "pwd" "snakeoilpwd"}}";
          };
        };
      };

      systemd.tmpfiles.rules =
        let
          dashboard = pkgs.writeText "test.json" (builtins.readFile ./test_dashboard.json);
        in
        [
          "d /var/lib/grafana/dashboards 0700 grafana grafana -"
          "C+ /var/lib/grafana/dashboards/test.json - - - - ${dashboard}"
        ];
    };

    extraNodeConfs = {
      provisionLegacyNotifiers = {
        services.grafana.provision = {
          datasources.settings = {
            apiVersion = 1;
            datasources = [
              {
                name = "Test Datasource";
                type = "testdata";
                access = "proxy";
                uid = "test_datasource";
              }
            ];
          };
          dashboards.settings = {
            apiVersion = 1;
            providers = [
              {
                name = "default";
                options.path = "/var/lib/grafana/dashboards";
              }
            ];
          };
          notifiers = [
            {
              uid = "test_notifiers";
              name = "Test Notifiers";
              type = "email";
              settings = {
                singleEmail = true;
                addresses = "test@test.com";
              };
            }
          ];
        };
      };
      provisionNix = {
        services.grafana.provision = {
          datasources.settings = {
            apiVersion = 1;
            datasources = [
              {
                name = "Test Datasource";
                type = "testdata";
                access = "proxy";
                uid = "test_datasource";
              }
            ];
          };

          dashboards.settings = {
            apiVersion = 1;
            providers = [
              {
                name = "default";
                options.path = "/var/lib/grafana/dashboards";
              }
            ];
          };

          alerting = {
            rules.settings = {
              groups = [
                {
                  name = "test_rule_group";
                  folder = "test_folder";
                  interval = "60s";
                  rules = [
                    {
                      uid = "test_rule";
                      title = "Test Rule";
                      condition = "A";
                      data = [
                        {
                          refId = "A";
                          datasourceUid = "-100";
                          model = {
                            conditions = [
                              {
                                evaluator = {
                                  params = [ 3 ];
                                  type = "git";
                                };
                                operator.type = "and";
                                query.params = [ "A" ];
                                reducer.type = "last";
                                type = "query";
                              }
                            ];
                            datasource = {
                              type = "__expr__";
                              uid = "-100";
                            };
                            expression = "1==0";
                            intervalMs = 1000;
                            maxDataPoints = 43200;
                            refId = "A";
                            type = "math";
                          };
                        }
                      ];
                      for = "60s";
                    }
                  ];
                }
              ];
            };

            contactPoints.settings = {
              contactPoints = [
                {
                  name = "Test Contact Point";
                  receivers = [
                    {
                      uid = "test_contact_point";
                      type = "prometheus-alertmanager";
                      settings.url = "http://localhost:9000";
                    }
                  ];
                }
              ];
            };

            policies.settings = {
              policies = [
                {
                  receiver = "Test Contact Point";
                }
              ];
            };

            templates.settings = {
              templates = [
                {
                  name = "Test Template";
                  template = "Test message";
                }
              ];
            };

            muteTimings.settings = {
              muteTimes = [
                {
                  name = "Test Mute Timing";
                }
              ];
            };
          };
        };
      };

      provisionYaml = {
        services.grafana.provision = {
          datasources.path = ./datasources.yaml;
          dashboards.path = ./dashboards.yaml;
          alerting = {
            rules.path = ./rules.yaml;
            contactPoints.path = ./contact-points.yaml;
            policies.path = ./policies.yaml;
            templates.path = ./templates.yaml;
            muteTimings.path = ./mute-timings.yaml;
          };
        };
      };

      provisionYamlDirs =
        let
          mkdir = p: pkgs.writeTextDir (baseNameOf p) (builtins.readFile p);
        in
        {
          services.grafana.provision = {
            datasources.path = mkdir ./datasources.yaml;
            dashboards.path = mkdir ./dashboards.yaml;
            alerting = {
              rules.path = mkdir ./rules.yaml;
              contactPoints.path = mkdir ./contact-points.yaml;
              policies.path = mkdir ./policies.yaml;
              templates.path = mkdir ./templates.yaml;
              muteTimings.path = mkdir ./mute-timings.yaml;
            };
          };
        };
    };

    nodes = builtins.mapAttrs (
      _: val:
      mkMerge [
        val
        baseGrafanaConf
      ]
    ) extraNodeConfs;
  in
  {
    name = "grafana-provision";

    meta = with maintainers; {
      maintainers = [
        kfears
        willibutz
      ];
    };

    inherit nodes;

    testScript = ''
      start_all()

      nodeNix = ("Nix (new format)", provisionNix)
      nodeYaml = ("Nix (YAML)", provisionYaml)
      nodeYamlDir = ("Nix (YAML in dirs)", provisionYamlDirs)

      for description, machine in [nodeNix, nodeYaml, nodeYamlDir]:
          with subtest(f"Should start provision node: {description}"):
              machine.wait_for_unit("grafana.service")
              machine.wait_for_open_port(3000)

          with subtest(f"Successful datasource provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/datasources/uid/test_datasource | grep Test\ Datasource"
              )

          with subtest(f"Successful dashboard provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/dashboards/uid/test_dashboard | grep Test\ Dashboard"
              )

          with subtest(f"Successful rule provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/alert-rules/test_rule | grep Test\ Rule"
              )

          with subtest(f"Successful contact point provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/contact-points | grep Test\ Contact\ Point"
              )

          with subtest(f"Successful policy provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/policies | grep Test\ Contact\ Point"
              )

          with subtest(f"Successful template provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/templates | grep Test\ Template"
              )

          with subtest("Successful mute timings provision with {description}"):
              machine.succeed(
                  "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/mute-timings | grep Test\ Mute\ Timing"
              )

      with subtest("Successful notifiers provision"):
          provisionLegacyNotifiers.wait_for_unit("grafana.service")
          provisionLegacyNotifiers.wait_for_open_port(3000)
          print(provisionLegacyNotifiers.succeed(
              "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/alert-notifications/uid/test_notifiers"
          ))
          provisionLegacyNotifiers.succeed(
              "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/alert-notifications/uid/test_notifiers | grep Test\ Notifiers"
          )
    '';
  }
)
