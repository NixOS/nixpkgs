{ lib, ... }:
{
  name = "crowdsec-full";
  meta.maintainers = with lib.maintainers; [ tornax ];

  nodes =
    let
      hub-addr = "127.0.0.1";
    in
    {
      attacker = { ... }: { };

      crowdsec =
        { pkgs, ... }:
        {
          # crowdsec needs the files from caddy
          systemd.services.crowdsec.after = [ "caddy.service" ];

          # for interactive with non-root users
          security.sudo-rs.enable = true;

          # useful for debugging
          environment.systemPackages = with pkgs; [
            file
          ];

          # to test auto completion for different shells
          programs = {
            fish.enable = true;
            zsh.enable = true;
          };

          users.users.nixos = {
            useDefaultShell = true;
            isNormalUser = true;
            password = "nixos";
            extraGroups = [
              "wheel"
            ];
          };

          services = {
            openssh.enable = true;

            caddy = {
              enable = true;

              # serve local hub
              virtualHosts = {
                "http://${hub-addr}".extraConfig = ''
                  handle_path /master/* {
                    root ${./data/hub}
                    file_server
                  }

                  handle_path /geolite/* {
                    root ${./data/geolite}
                    file_server
                  }

                  handle_path /cloudflare/* {
                    root ${./data/cloudflare}
                    file_server
                  }
                '';
              };
            };

            crowdsec-firewall-bouncer.enable = true;

            crowdsec = {
              enable = true;
              autoUpdateService = true;
              openFirewall = true;
              hub = {
                collections = [
                  "crowdsecurity/linux"
                  "Dominic-Wagner/vaultwarden"
                  "crowdsecurity/nginx"
                  "crowdsecurity/base-http-scenarios"
                  "crowdsecurity/auditd"
                  "crowdsecurity/appsec-generic-rules"
                  "crowdsecurity/appsec-virtual-patching"
                  "crowdsecurity/home-assistant"
                  "crowdsecurity/http-dos"
                ];
                scenarios = [
                  "crowdsecurity/ssh-bf"
                  "crowdsecurity/http-path-traversal-probing"
                  "crowdsecurity/http-probing"
                  "crowdsecurity/http-sensitive-files"
                  "crowdsecurity/http-sqli-probing"
                  "crowdsecurity/http-xss-probing"
                  "crowdsecurity/http-generic-test"
                ];
                parsers = [
                  "crowdsecurity/sshd-logs"
                  "crowdsecurity/nginx-logs"
                  "crowdsecurity/http-logs"
                ];
                postoverflows = [
                  "crowdsecurity/auditd-nix-wrappers-whitelist-process"
                  "crowdsecurity/auditd-whitelisted-process"
                ];
                appsec-configs = [ "crowdsecurity/appsec-default" ];
                appsec-rules = [ "crowdsecurity/base-config" ];
              };
              settings = {
                config = {
                  api = {
                    client = {
                      insecure_skip_verify = true;
                    };
                  };

                  cscli = {
                    hub_branch = "master";
                    __hub_url_template__ = "http://${hub-addr}/%s/%s";
                  };
                };

                scenarios = [
                  {
                    type = "trigger";
                    name = "ssh-bruteforce-test";
                    description = "For NixOS test";
                    filter = "evt.Meta.log_type == 'ssh_failed-auth'";
                    groupby = "evt.Meta.source_ip";
                    labels = {
                      service = "ssh";
                      confidence = 3;
                      spoofable = 0;
                      classification = [
                        "attack.T1110"
                      ];
                      label = "SSH Bruteforce";
                      behavior = "ssh:bruteforce";
                      remediation = true;
                    };
                  }
                ];

                acquisitions = [
                  {
                    source = "journalctl";
                    journalctl_filter = [
                      "_SYSTEMD_UNIT=sshd.service"
                    ];
                    labels = {
                      type = "syslog";
                    };
                  }
                  {
                    source = "journalctl";
                    journalctl_filter = [
                      "_SYSTEMD_UNIT=podman-home-assistant.service"
                    ];
                    labels = {
                      type = "home-assistant";
                    };
                  }
                  {
                    source = "file";
                    filenames = [
                      "/var/log/nginx/*.log"
                    ];
                    labels = {
                      type = "nginx";
                    };
                  }
                  {
                    source = "file";
                    filenames = [
                      "/var/log/audit/*.log"
                    ];
                    labels = {
                      type = "auditd";
                    };
                  }
                  {
                    source = "file";
                    filenames = [
                      "/srv/vaultwarden2/var/log/vaultwarden2/*.log"
                    ];
                    labels = {
                      type = "vaultwarden";
                    };
                  }
                ];

                notifications = [
                  {
                    type = "http";
                    name = "http_default";
                    log_level = "info";
                    format = ''
                      {{ range . -}}
                      {{ $alert := . -}}
                      {{ range .Decisions -}}
                      {
                        "extras": {
                          "client::display": {
                            "contentType": "text/markdown"
                          }
                        },
                        "priority": 3,
                        "title": "{{.Type}} {{.Value}} for {{.Duration}}",
                        "message": "{{.Scenario}}\n\n[crowdsec cti](https://app.crowdsec.net/cti/{{.Value}})\n\n[shodan](https://shodan.io/host/{{.Value}})"
                      }
                      {{end -}}
                      {{end -}}
                    '';
                    url = "http://127.0.0.1";
                    method = "POST";
                    headers = {
                      "Content-Type" = "application/json";
                    };
                  }
                  {
                    type = "http";
                    name = "auditd_default";
                    log_level = "info";
                    format = ''
                      {{ range . -}}
                      {{ $alert := . -}}
                      {
                        "priority": 5,
                        "title": "{{$alert.Scenario}}",
                        "message": "auditd alert"
                      }
                      {{end -}}
                    '';
                    url = "http://127.0.0.1";
                    method = "POST";
                    headers = {
                      "Content-Type" = "application/json";
                    };
                  }
                ];

                profiles = [
                  {
                    name = "default_ip_remediation";
                    filters = [ "Alert.Remediation == true && Alert.GetScope() == 'Ip'" ];
                    decisions = [
                      {
                        type = "ban";
                        duration = "4h";
                      }
                    ];
                    notifications = [
                      "http_default"
                    ];
                    on_success = "break";
                  }
                  {
                    name = "default_range_remediation";
                    filters = [ "Alert.Remediation == true && Alert.GetScope() == 'Range'" ];
                    decisions = [
                      {
                        type = "ban";
                        duration = "4h";
                      }
                    ];
                    notifications = [
                      "http_default"
                    ];
                    on_success = "break";
                  }
                  {
                    name = "pid_alert";
                    filters = [ "Alert.GetScope() == 'pid'" ];
                    decisions = [
                      {
                        type = "ban";
                        duration = "4h";
                      }
                    ];
                    notifications = [
                      "auditd_default"
                    ];
                    on_success = "break";
                  }
                ];
              };
            };
          };

        };
    };

  testScript = ''
    start_all()
    crowdsec.wait_for_unit("multi-user.target")

    # services should work
    crowdsec.succeed("pgrep --exact crowdsec")
    crowdsec.succeed("pgrep --full crowdsec-firewall-bouncer")

    # check if some commands work
    crowdsec.succeed("""\
      cscli explain\
        --type easytier\
        --log \"conn19:34 [30/1984] ocal: udp://12.12.12.12:11010, remote: udp://46.11.22.123:14947, err: wait resp error: wait handshake timeout: Elapsed(())\"
      """);

    t.assertIsNot("", crowdsec.succeed("cscli metrics --output json"))
    t.assertIn("You can successfully interact with Local API (LAPI)", crowdsec.succeed("cscli lapi status"))
    t.assertIsNot("", crowdsec.succeed("cscli bouncers list --output json"))
    t.assertIn("http_default", crowdsec.succeed("cscli notifications list --output raw"))
  '';

  interactive.sshBackdoor.enable = true;
}
