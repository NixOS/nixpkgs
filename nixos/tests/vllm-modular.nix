{ lib, ... }:
let
  # vLLM is marked as broken, and testing it requires downloading model
  fakeVllm =
    pkgs:
    pkgs.writeShellApplication {
      name = "vllm";
      text = "exit 0";
    };
in
{
  _class = "nixosTest";

  name = "vllm-modular";

  nodes.machine =
    { pkgs, ... }:
    {
      system.services.vllm = {
        imports = [ pkgs.vllm.services.default ];
        vllm = {
          package = lib.mkForce (fakeVllm pkgs);
          settings = {
            listen = "127.0.0.1";
            port = 8080;
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 8080 ];
    };

  nodes.noSettings =
    { pkgs, ... }:
    {
      system.services.vllm = {
        imports = [ pkgs.vllm.services.default ];
        vllm = {
          package = lib.mkForce (fakeVllm pkgs);
          settings = null;
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    noSettings.wait_for_unit("multi-user.target")

    # Test config
    machine.succeed("test -f /etc/system-services/vllm/config.yaml")
    machine.succeed("grep -q '\"host\":\"127.0.0.1\"' /etc/system-services/vllm/config.yaml")
    machine.succeed("grep -q '\"port\":8080' /etc/system-services/vllm/config.yaml")

    # Test command flags
    machine.succeed("systemctl cat vllm.service | grep -F -- '--config'")
    machine.succeed("systemctl cat vllm.service | grep -F -- '/etc/system-services/vllm/config.yaml'")

    # Test absence of config nad command flags when settings = null
    noSettings.fail("test -e /etc/system-services/vllm/config.yaml")
    noSettings.fail("systemctl cat vllm.service | grep -F -- '--config'")
  '';

  meta.maintainers = with lib.maintainers; [ weathercold ];
}
