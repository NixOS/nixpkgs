{ pkgs, ... }:
{
  name = "atlantis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ jwygoda ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.atlantis = {
        enable = true;
        serverArgs = {
          atlantis-url = "https://atlantis.example.com";
          gh-user = "github_user";
          gh-token = "github_token";
          gh-webhook-secret = "webhook_secret";
          repo-allowlist = "github.com/yourorg/yourrepo";
          default-tf-version = "1.12.2";
        };
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("atlantis.service")
    machine.wait_for_open_port(4141)
    machine.succeed("curl --fail http://127.0.0.1:4141")
  '';
}
