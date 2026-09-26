{ lib, pkgs, ... }:

let
  stateDir = "/var/lib/portmaster-test";

  fakeApi = pkgs.writeText "fake-portmaster-api.py" ''
    import json
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
    from urllib.parse import urlparse

    imports_path = "${stateDir}/imports.jsonl"

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, format, *args):
            pass

        def send_json(self, status, value):
            payload = json.dumps(value).encode()
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)

        def do_GET(self):
            if urlparse(self.path).path == "/api/v1/ping":
                self.send_json(200, {"status": "ok"})
            else:
                self.send_json(404, {"error": "not found"})

        def do_POST(self):
            if urlparse(self.path).path != "/api/v1/sync/profile/import":
                self.send_json(404, {"error": "not found"})
                return

            length = int(self.headers.get("Content-Length", "0"))
            profile = json.loads(self.rfile.read(length))
            with open(imports_path, "a", encoding="utf-8") as imports:
                imports.write(json.dumps(profile, sort_keys=True) + "\n")

            if profile.get("name") == "[NixOS] Rejected":
                self.send_json(422, {"error": "profile rejected for test"})
            else:
                self.send_json(200, {
                    "restartRequired": False,
                    "replacesExisting": False,
                })

    ThreadingHTTPServer(("127.0.0.1", 817), Handler).serve_forever()
  '';

  fakeCore = pkgs.writeShellApplication {
    name = "portmaster-core";
    text = ''
      if [ "''${1:-}" = "recover-iptables" ]; then
        exit 0
      fi
      exec ${lib.getExe pkgs.python3} ${fakeApi}
    '';
  };

  fakeDesktop = pkgs.writeShellApplication {
    name = "portmaster";
    text = "exit 0";
  };

  contextPackage = pkgs.writeShellApplication {
    name = "portmaster-context-test";
    text = "exit 0";
  };

  fakePortmaster = pkgs.runCommandLocal "fake-portmaster" { } ''
    mkdir -p $out/bin $out/lib/portmaster
    ln -s ${fakeCore}/bin/portmaster-core $out/bin/portmaster-core
    ln -s ${fakeCore}/bin/portmaster-core $out/lib/portmaster/portmaster-core
    ln -s ${fakeDesktop}/bin/portmaster $out/bin/portmaster
    touch $out/lib/portmaster/portmaster.zip
    touch $out/lib/portmaster/assets.zip
  '';
in
{
  name = "portmaster";
  meta.maintainers = with lib.maintainers; [
    WitteShadovv
    nyabinary
  ];

  nodes.machine = { lib, ... }: {
    environment.systemPackages = [ pkgs.jq ];

    services.portmaster = {
      enable = true;
      package = fakePortmaster;
      inherit stateDir;
      settings = {
        devmode = true;
        "core/devMode" = false;
        "core/log/level" = "warning";
        nested = {
          fromSettings = true;
          shared = "settings";
        };
      };
      settingsFile = "/run/portmaster-settings.json";
      secretsFile = "/run/portmaster-secrets.json";
      profilePrefix = "[NixOS] ";
      profiles = {
        Hello = {
          packages = [ pkgs.hello ];
          settings.filter.defaultAction = "permit";
        };
        Go.packages = [
          {
            package = pkgs.go;
            directory = "share/go/bin";
          }
        ];
        Extcap.packages = [
          {
            package = pkgs.wireshark;
            directory = "libexec/wireshark/extcap";
            name = null;
            strictLast = false;
          }
        ];
        Combined = {
          packages = [
            pkgs.hello
            {
              package = pkgs.go;
              directory = "share/go/bin";
            }
          ];
          fingerprints = [
            {
              type = "env";
              key = "COMBINED_TEST";
              operation = "equals";
              value = "1";
            }
          ];
        };
        Context.fingerprints = [
          {
            type = "path";
            operation = "equals";
            value = builtins.unsafeDiscardStringContext "${contextPackage}/bin/portmaster-context-test";
          }
          {
            type = "path";
            operation = "equals";
            value = "${contextPackage}/bin/portmaster-context-test";
          }
        ];
        StoreRegex.packages = [
          {
            package = pkgs.hello;
            type = "cmdline";
            storeNameRegex = "hello-[0-9.]+";
            strictHead = false;
          }
        ];
        Vesktop.fingerprints = [
          {
            type = "env";
            key = "CHROME_DESKTOP";
            operation = "equals";
            value = "vesktop.desktop";
          }
        ];
        Tagged.fingerprints = [
          {
            type = "tag";
            key = "vendor";
            operation = "prefix";
            value = "Safing";
          }
        ];
      };
    };

    specialisation = {
      rejected.configuration.services.portmaster.profiles = lib.mkForce {
        Rejected.fingerprints = [
          {
            type = "path";
            operation = "equals";
            value = "/bin/rejected";
          }
        ];
      };

      unmanaged.configuration.services.portmaster = {
        settings = lib.mkForce { };
        settingsFile = lib.mkForce null;
        secretsFile = lib.mkForce null;
        profiles = lib.mkForce { };
      };

      development.configuration.services.portmaster = {
        settings = lib.mkForce { devmode = true; };
        settingsFile = lib.mkForce null;
        secretsFile = lib.mkForce null;
        profiles = lib.mkForce { };
      };
    };

    systemd.services.portmaster-test-inputs = {
      wantedBy = [ "portmaster.service" ];
      before = [ "portmaster.service" ];
      requiredBy = [ "portmaster.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        cat > /run/portmaster-settings.json <<'EOF'
        {
          "core/log/level": "error",
          "nested": {
            "fromFile": true,
            "shared": "settings-file"
          }
        }
        EOF

        cat > /run/portmaster-secrets.json <<'EOF'
        {
          "nested": {
            "shared": "secrets-file"
          },
          "secret/value": "kept-out-of-store"
        }
        EOF

        chmod 0600 /run/portmaster-settings.json /run/portmaster-secrets.json
      '';
    };
  };

  testScript =
    { nodes, ... }:
    let
      rejected = "${nodes.machine.system.build.toplevel}/specialisation/rejected";
      unmanaged = "${nodes.machine.system.build.toplevel}/specialisation/unmanaged";
      development = "${nodes.machine.system.build.toplevel}/specialisation/development";
    in
    ''
      machine.wait_for_unit("portmaster.service")
      machine.wait_for_unit("portmaster-managed-profiles.service")
      machine.succeed("grep -Fx nfnetlink_queue /etc/modules-load.d/nixos.conf")
      machine.fail("grep -Fx netfilter_queue /etc/modules-load.d/nixos.conf")
      machine.fail("test -e /usr/lib/portmaster/assets.zip")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--bin-dir=${fakePortmaster}/lib/portmaster'")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--data-dir=${stateDir}'")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--log-dir=${stateDir}/logs'")
      machine.succeed("systemctl cat portmaster.service | grep -F 'ReadOnlyPaths=/nix/store'")
      machine.fail("systemctl cat portmaster.service | grep -F -- '--devmode'")

      machine.succeed("test -f ${stateDir}/config.json")
      machine.succeed("test \"$(stat -c %a ${stateDir}/config.json)\" = 600")
      machine.succeed("jq -e '.\"core/devMode\" == false' ${stateDir}/config.json")
      machine.succeed("jq -e 'has(\"devmode\") | not' ${stateDir}/config.json")
      machine.succeed("jq -e '.\"core/log/level\" == \"error\"' ${stateDir}/config.json")
      machine.succeed("jq -e '.nested.fromSettings == true' ${stateDir}/config.json")
      machine.succeed("jq -e '.nested.fromFile == true' ${stateDir}/config.json")
      machine.succeed("jq -e '.nested.shared == \"secrets-file\"' ${stateDir}/config.json")
      machine.succeed("jq -e '.\"secret/value\" == \"kept-out-of-store\"' ${stateDir}/config.json")
      machine.succeed("test -f ${stateDir}/.config.json.nix-managed")
      machine.succeed("test \"$(stat -c %a ${stateDir}/.config.json.nix-managed)\" = 600")
      machine.succeed("test \"$(stat -c %a ${stateDir}/config/nix-managed-profiles-api-key)\" = 600")
      machine.succeed(r"""key=$(cat ${stateDir}/config/nix-managed-profiles-api-key); jq --arg key "$key?read=admin&write=admin" -e '."core/apiKeys" | index($key)' ${stateDir}/config.json""")

      machine.succeed("jq -se 'map(select(.name == \"[NixOS] Hello\")) | length == 1' ${stateDir}/imports.jsonl")
      machine.succeed("jq -se 'any(.[]; .name == \"[NixOS] Vesktop\" and .fingerprints == [{\"key\":\"CHROME_DESKTOP\",\"operation\":\"equals\",\"type\":\"env\",\"value\":\"vesktop.desktop\"}])' ${stateDir}/imports.jsonl")
      machine.succeed("jq -se 'any(.[]; .name == \"[NixOS] Tagged\" and .fingerprints[0].type == \"tag\" and .fingerprints[0].operation == \"prefix\")' ${stateDir}/imports.jsonl")
      machine.fail("grep -F '${pkgs.hello}' ${stateDir}/imports.jsonl")
      machine.succeed(r"""regex=$(jq -r 'select(.name == "[NixOS] Hello") | .fingerprints[0].value' ${stateDir}/imports.jsonl); matches=$(printf '%s\n' '/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hello-2.12.2/bin/hello' '/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hello-2.12.2/bin/.hello-wrapped' | grep -E "$regex" | wc -l); test "$matches" -eq 2""")
      machine.succeed(r"""regex=$(jq -r 'select(.name == "[NixOS] Hello") | .fingerprints[0].value' ${stateDir}/imports.jsonl); ! printf '%s\n' '/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hello-2.12.2/bin/not-hello' | grep -Eq "$regex";""")
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] Go") | .fingerprints[0].value' ${stateDir}/imports.jsonl | grep -F '/share/go/bin/' """)
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] Extcap") | .fingerprints[0].value' ${stateDir}/imports.jsonl | grep -F '/libexec/wireshark/extcap/' """)
      machine.fail(r"""jq -r 'select(.name == "[NixOS] Extcap") | .fingerprints[0].value' ${stateDir}/imports.jsonl | grep -F '.*' """)
      machine.succeed("jq -se 'any(.[]; .name == \"[NixOS] Combined\" and (.fingerprints | length == 3) and any(.fingerprints[]; .type == \"env\" and .key == \"COMBINED_TEST\" and .value == \"1\"))' ${stateDir}/imports.jsonl")
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] Combined") | .fingerprints[] | select(.type == "path" and (.value | contains("hello"))) | .value' ${stateDir}/imports.jsonl | grep -F '/bin/' """)
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] Combined") | .fingerprints[] | select(.value | contains("share/go/bin")) | .value' ${stateDir}/imports.jsonl | grep -F '/share/go/bin/' """)
      machine.succeed(r"""jq -e 'select(.name == "[NixOS] Context") | .fingerprints | length == 1' ${stateDir}/imports.jsonl; context_path=$(jq -r 'select(.name == "[NixOS] Context") | .fingerprints[0].value' ${stateDir}/imports.jsonl); test -x "$context_path" """)
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] StoreRegex") | .fingerprints[0] | select(.type == "cmdline") | .value' ${stateDir}/imports.jsonl | grep -E '^/nix/store/\[a-z0-9\]' """)
      machine.succeed(r"""jq -r 'select(.name == "[NixOS] StoreRegex") | .fingerprints[0].value' ${stateDir}/imports.jsonl | grep -F 'hello-[0-9.]+' """)

      machine.execute("${rejected}/bin/switch-to-configuration test >&2")
      machine.fail("systemctl restart portmaster-managed-profiles.service")
      machine.succeed("journalctl -u portmaster-managed-profiles.service --no-pager | grep -F 'Failed to import Portmaster profile `Rejected`'")
      machine.succeed("journalctl -u portmaster-managed-profiles.service --no-pager | grep -F 'profile rejected for test'")

      machine.succeed("${unmanaged}/bin/switch-to-configuration test >&2")
      machine.wait_for_unit("portmaster.service")
      machine.fail("systemctl cat portmaster.service | grep -F -- '--devmode'")
      machine.succeed("test ! -e ${stateDir}/config.json")
      machine.succeed("test ! -e ${stateDir}/.config.json.nix-managed")
      machine.succeed("test ! -e ${stateDir}/config/nix-managed-profiles-api-key")

      machine.succeed("printf '%s\n' '{\"manual\":true}' > ${stateDir}/config.json")
      machine.succeed("chmod 0600 ${stateDir}/config.json")

      machine.succeed("${unmanaged}/bin/switch-to-configuration test >&2")
      machine.wait_for_unit("portmaster.service")
      machine.succeed("test -f ${stateDir}/config.json")
      machine.succeed("jq -e '.manual == true' ${stateDir}/config.json")
      machine.succeed("test ! -e ${stateDir}/.config.json.nix-managed")

      machine.succeed("${development}/bin/switch-to-configuration test >&2")
      machine.wait_for_unit("portmaster.service")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--devmode'")
    '';
}
