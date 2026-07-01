{ lib, pkgs, ... }:

let
  fakePortmaster = pkgs.runCommandLocal "fake-portmaster" { } ''
    mkdir -p $out/lib/portmaster $out/bin

    cat > $out/lib/portmaster/portmaster-core <<'EOF'
    #!${pkgs.runtimeShell}
    set -eu
    if [ "''${1:-}" = "recover-iptables" ]; then
      exit 0
    fi
    while [ ! -f /tmp/portmaster-stop ]; do
      sleep 1
    done
    EOF
    chmod +x $out/lib/portmaster/portmaster-core

    cat > $out/lib/portmaster/portmaster <<'EOF'
    #!${pkgs.runtimeShell}
    exit 0
    EOF
    chmod +x $out/lib/portmaster/portmaster

    touch $out/lib/portmaster/portmaster.zip
    touch $out/lib/portmaster/assets.zip

    ln -s $out/lib/portmaster/portmaster-core $out/bin/portmaster-core
    ln -s $out/lib/portmaster/portmaster $out/bin/portmaster
  '';
in
{
  name = "portmaster";
  meta.maintainers = with lib.maintainers; [
    WitteShadovv
    nyabinary
  ];

  nodes.machine =
    { lib, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];

      services.portmaster = {
        enable = true;
        package = fakePortmaster;
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
      };

      specialisation.unmanaged.configuration = {
        services.portmaster = {
          settings = lib.mkForce { };
          settingsFile = lib.mkForce null;
          secretsFile = lib.mkForce null;
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
      unmanaged = "${nodes.machine.system.build.toplevel}/specialisation/unmanaged";
    in
    ''
      machine.wait_for_unit("portmaster.service")
      machine.succeed("grep -Fx nfnetlink_queue /etc/modules-load.d/nixos.conf")
      machine.fail("grep -Fx netfilter_queue /etc/modules-load.d/nixos.conf")
      machine.succeed("test -L /usr/lib/portmaster/assets.zip")
      machine.succeed("test \"$(readlink -f /usr/lib/portmaster/assets.zip)\" = \"$(readlink -f /var/lib/portmaster/runtime/assets.zip)\"")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--data-dir=/var/lib/portmaster/runtime'")
      machine.fail("systemctl cat portmaster.service | grep -F -- '--devmode'")
      machine.succeed("test -f /var/lib/portmaster/runtime/config.json")
      machine.succeed("test \"$(stat -c %a /var/lib/portmaster/runtime/config.json)\" = 600")
      machine.succeed("jq -e '.\"core/devMode\" == false' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e 'has(\"devmode\") | not' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.\"core/log/level\" == \"error\"' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.nested.fromSettings == true' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.nested.fromFile == true' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.nested.shared == \"secrets-file\"' /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.\"secret/value\" == \"kept-out-of-store\"' /var/lib/portmaster/runtime/config.json")
      machine.succeed("test -f /var/lib/portmaster/runtime/.config.json.nix-managed")
      machine.succeed("test \"$(stat -c %a /var/lib/portmaster/runtime/.config.json.nix-managed)\" = 600")

      machine.succeed("${unmanaged}/bin/switch-to-configuration test >&2")
      machine.wait_for_unit("portmaster.service")
      machine.succeed("systemctl cat portmaster.service | grep -F -- '--devmode'")
      machine.succeed("test ! -e /var/lib/portmaster/runtime/config.json")
      machine.succeed("test ! -e /var/lib/portmaster/runtime/.config.json.nix-managed")

      machine.succeed("printf '%s\n' '{\"manual\":true}' > /var/lib/portmaster/runtime/config.json")
      machine.succeed("chmod 0600 /var/lib/portmaster/runtime/config.json")

      machine.succeed("${unmanaged}/bin/switch-to-configuration test >&2")
      machine.wait_for_unit("portmaster.service")
      machine.succeed("test -f /var/lib/portmaster/runtime/config.json")
      machine.succeed("jq -e '.manual == true' /var/lib/portmaster/runtime/config.json")
      machine.succeed("test ! -e /var/lib/portmaster/runtime/.config.json.nix-managed")
    '';
}
