{ lib, ... }:
{
  name = "cloudflared";
  meta.maintainers = with lib.maintainers; [ arunoruto ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.cloudflared = {
        enable = true;
        tunnels = {
          attrs = {
            credentialsFile = "/dev/null";
            default = "http_status:404";
            ingress = {
              "b.example.com" = "http://localhost:1";
              "*.example.com" = "http://localhost:2";
              "a.example.com" = {
                service = "http://localhost:3";
                originRequest.noTLSVerify = true;
              };
            };
          };
          list = {
            credentialsFile = "/dev/null";
            default = "http_status:404";
            ingressList = [
              {
                hostname = "app.example.com";
                path = "/api/.*";
                service = "http://localhost:8080";
              }
              {
                hostname = "app.example.com";
                service = "http://localhost:3000";
              }
              {
                hostname = "*.example.com";
                service = "http://localhost:80";
              }
            ];
          };
          both = {
            credentialsFile = "/dev/null";
            default = "http_status:404";
            ingress."*.example.com" = "http://localhost:2";
            ingressList = [
              {
                hostname = "app.example.com";
                service = "http://localhost:1";
              }
            ];
          };
        };
      };

      # no internet access in the VM
      systemd.services = {
        cloudflared-tunnel-attrs.wantedBy = lib.mkForce [ ];
        cloudflared-tunnel-list.wantedBy = lib.mkForce [ ];
        cloudflared-tunnel-both.wantedBy = lib.mkForce [ ];
      };

      environment.systemPackages = [ pkgs.cloudflared ];
    };

  testScript = ''
    def config_of(tunnel):
        return machine.succeed(
            f"systemctl show -P ExecStart cloudflared-tunnel-{tunnel} | grep -o '/nix/store/[^ ]*cloudflared.yml'"
        ).strip()

    def matched_service(config, url):
        out = machine.succeed(f"cloudflared tunnel --config {config} ingress rule {url}")
        return [l.split(": ", 1)[1] for l in out.splitlines() if l.strip().startswith("service:")][0]

    start_all()

    with subtest("Rules given as an attribute set keep their order"):
        config = config_of("attrs")
        machine.succeed(f"cloudflared tunnel --config {config} ingress validate")
        # a is given as an attribute set, so it comes first; then "*" sorts before "b"
        assert matched_service(config, "https://a.example.com/") == "http://localhost:3"
        assert matched_service(config, "https://b.example.com/") == "http://localhost:2"
        assert matched_service(config, "https://example.org/") == "http_status:404"

    with subtest("Rules given as a list keep their order"):
        config = config_of("list")
        machine.succeed(f"cloudflared tunnel --config {config} ingress validate")
        assert matched_service(config, "https://app.example.com/api/users") == "http://localhost:8080"
        assert matched_service(config, "https://app.example.com/") == "http://localhost:3000"
        assert matched_service(config, "https://other.example.com/") == "http://localhost:80"
        assert matched_service(config, "https://example.org/") == "http_status:404"

    with subtest("Rules given as a list come before those given as an attribute set"):
        config = config_of("both")
        machine.succeed(f"cloudflared tunnel --config {config} ingress validate")
        assert matched_service(config, "https://app.example.com/") == "http://localhost:1"
        assert matched_service(config, "https://other.example.com/") == "http://localhost:2"
  '';
}
