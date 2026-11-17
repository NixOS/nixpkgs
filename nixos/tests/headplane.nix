{ lib, pkgs, ... }:
let
  cookieSecret = pkgs.writeText "cookie-secret" "01234567890123456789012345678901";
  oidcClientSecret = pkgs.writeText "oidc-client-secret" "client-secret";
  headscaleApiKey = pkgs.writeText "headscale-api-key" "headscale-api-key";
in
{
  name = "headplane";
  meta.maintainers = with lib.maintainers; [
    igor-ramazanov
    stealthbadger747
  ];

  nodes.machine = {
    services.headscale = {
      enable = true;
      settings = {
        server_url = "http://127.0.0.1";
        ip_prefixes = [ "100.64.0.0/10" ];
        dns = {
          base_domain = "tailnet";
          override_local_dns = false;
        };
      };
    };
    services.headplane = {
      enable = true;
      settings.server = {
        cookie_secret_path = cookieSecret;
        cookie_secure = false;
        # Exercise the new 0.6.2 server-level options so the test fails
        # if their option-name -> YAML-key mapping ever regresses.
        base_url = "http://127.0.0.1:3000";
        cookie_max_age = 3600;
        cookie_domain = "127.0.0.1";
      };
      settings.oidc = {
        enabled = false;
        issuer = "https://provider.example.com/issuer-url";
        client_id = "your-client-id";
        client_secret_path = oidcClientSecret;
        headscale_api_key_path = headscaleApiKey;
        redirect_uri = "http://127.0.0.1:3000/admin/oidc/callback";
        strict_validation = true;
        user_storage_file = "/var/lib/headplane/users.json";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("headscale.service")
    machine.wait_for_unit("headplane.service")
    machine.wait_until_succeeds("curl -sf http://127.0.0.1:3000/admin/login")

    with subtest("rendered config contains new and deprecated-compatible options"):
        config = machine.succeed("cat /etc/headplane/config.yaml")
        for key in ["base_url:", "cookie_max_age:", "cookie_domain:", "redirect_uri:", "strict_validation:", "user_storage_file:"]:
            assert key in config, f"{key} missing from rendered config"

    with subtest("unsupported options are not rendered"):
        config = machine.succeed("cat /etc/headplane/config.yaml")
        for key in ["info_secret_path:", "subject_claims:", "allow_weak_rsa_keys:", "use_end_session:", "end_session_endpoint:", "post_logout_redirect_uri:"]:
            assert key not in config, f"unsupported option {key} still rendered"

    with subtest("session cookie is set on login page"):
        machine.succeed("curl -sf -c /tmp/cj http://127.0.0.1:3000/admin/login")
        machine.succeed("test -s /tmp/cj")
  '';
}
