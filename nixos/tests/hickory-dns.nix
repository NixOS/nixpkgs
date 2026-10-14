{ pkgs, ... }:
{
  name = "hickory-dns";

  meta.maintainers = with pkgs.lib.maintainers; [ adamcstephens ];

  containers.machine = {
    environment.systemPackages = [ pkgs.doggo ];

    services.hickory-dns = {
      enable = true;
      settings.zones = [
        {
          zone = "example.test";
          file = pkgs.writeText "example.test.zone" ''
            $ORIGIN example.test.
            $TTL 3600
            @ IN SOA ns.example.test. hostmaster.example.test. (1 3600 600 86400 3600)
            @ IN NS ns.example.test.
            ns IN A 127.0.0.1
            www IN A 192.0.2.1
          '';
        }
      ];
    };
  };

  testScript = ''
    import json

    machine.start()
    machine.wait_for_unit("hickory-dns.service")
    machine.wait_for_open_port(53)

    response = json.loads(machine.succeed("doggo @127.0.0.1 www.example.test. A --json"))
    answers = response["responses"][0]["answers"]
    assert [(answer["name"], answer["type"], answer["address"]) for answer in answers] == [
        ("www.example.test.", "A", "192.0.2.1")
    ], response
  '';
}
