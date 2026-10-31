{ lib, ... }:

{
  name = "mesh-llm";
  meta.maintainers = with lib.maintainers; [ kleinbem ];

  nodes.machine =
    { pkgs, ... }:
    let
      # A throwaway owner identity for the test.
      ownerKeystore = pkgs.runCommand "mesh-llm-test-owner-keystore" { } ''
        HOME=$TMPDIR ${lib.getExe pkgs.mesh-llm} auth init --no-passphrase
        cp $TMPDIR/.mesh-llm/owner-keystore.json $out
      '';
    in
    {
      environment.etc."mesh-llm/owner-keystore.json".source = ownerKeystore;
      services.mesh-llm = {
        enable = true;
        settings = {
          version = 1;
          # A 1 MB model, so inference runs under the service's sandboxing.
          models = [
            {
              model = pkgs.fetchurl {
                url = "https://huggingface.co/ggml-org/models-moved/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf";
                hash = "sha256-Jwy6G9UQn0LQM1D2BAYCRWBGTbFzwOOH2R8EJtO9JW0=";
              };
            }
          ];
        };
        meshPort = 7842;
        openFirewall = true;
        ownerKeyFile = "/etc/mesh-llm/owner-keystore.json";
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.jq
        pkgs.mesh-llm
      ];
      virtualisation.memorySize = 2048;
    };

  testScript = ''
    import datetime as dt

    machine.wait_for_unit("mesh-llm.service")
    machine.wait_for_open_port(9337)
    machine.wait_for_open_port(3131)

    with subtest("console and management API answer"):
        page = machine.succeed("curl -fsS http://127.0.0.1:3131/")
        assert "<html" in page.lower(), "the console must serve its web UI"
        machine.succeed("curl -fsS http://127.0.0.1:3131/api/status")

    with subtest("the node finds its host name"):
        machine.succeed("curl -fsS http://127.0.0.1:3131/api/status | jq -e '.my_hostname == \"machine\"'")

    with subtest("the service serves its model"):
        machine.wait_until_succeeds("curl -fsS http://127.0.0.1:9337/v1/models | jq -e '.data | length > 0'", timeout=dt.timedelta(minutes=2))
        model = machine.succeed("curl -fsS http://127.0.0.1:9337/v1/models | jq -r '.data[0].id'").strip()
        request = f'{{"model": "{model}", "prompt": "Once upon a time", "max_tokens": 8}}'
        machine.succeed(
            f"curl -fsS http://127.0.0.1:9337/v1/completions -H 'Content-Type: application/json' -d '{request}'"
            " | jq -e '.choices[0].text | length > 0'"
        )

    with subtest("the node is attested by the owner key"):
        owner = machine.succeed("jq -r .owner_id /etc/mesh-llm/owner-keystore.json").strip()
        machine.succeed(
            "curl -fsS http://127.0.0.1:3131/api/status"
            f" | jq -e '.owner.status == \"verified\" and .owner.owner_id == \"{owner}\"'"
        )

    with subtest("settings are installed in the node's home"):
        machine.succeed("grep -qx 'version = 1' /var/lib/mesh-llm/.mesh-llm/config.toml")

    with subtest("QUIC listens on the fixed mesh port, and the firewall allows it"):
        machine.wait_until_succeeds("ss -Hulnp | grep -q ':7842 '")
        machine.succeed("iptables -S | grep -q 'udp.*--dport 7842'")

    with subtest("the Nix-built runtimes are found"):
        out = machine.succeed("HOME=/tmp mesh-llm runtime list 2>&1")
        assert "-nixpkgs" in out, out
  '';
}
