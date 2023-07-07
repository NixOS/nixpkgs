import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "pomerium";
  meta = with lib.maintainers; {
    maintainers = [ lukegb ];
  };

  nodes = let base = myIP: { pkgs, lib, ... }: {
    virtualisation.vlans = [ 1 ];
    networking = {
      dhcpcd.enable = false;
      firewall.allowedTCPPorts = [ 80 443 ];
      hosts = {
        "192.168.1.1" = [ "pomerium" "pom-auth" ];
        "192.168.1.2" = [ "backend" "dummy-oidc" ];
      };
      interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
        { address = myIP; prefixLength = 24; }
      ];
    };
  }; in {
    pomerium = { pkgs, lib, ... }: {
      imports = [ (base "192.168.1.1") ];
      environment.systemPackages = with pkgs; [ chromium ];
      services.pomerium = {
        enable = true;
        settings = {
          address = ":80";
          insecure_server = true;
          authenticate_service_url = "http://pom-auth";

          idp_provider = "oidc";
          idp_scopes = [ "oidc" ];
          idp_client_id = "dummy";
          idp_provider_url = "http://dummy-oidc";

          policy = [{
            from = "https://my.website";
            to = "http://192.168.1.2";
            allow_public_unauthenticated_access = true;
            preserve_host_header = true;
          } {
            from = "https://login.required";
            to = "http://192.168.1.2";
            allowed_domains = [ "my.domain" ];
            preserve_host_header = true;
          }];
        };
        secretsFile = pkgs.writeText "pomerium-secrets" ''
          # 12345678901234567890123456789012 in base64
          COOKIE_SECRET=MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI=
          IDP_CLIENT_SECRET=dummy
        '';
      };
    };
    backend = { pkgs, lib, ... }: {
      imports = [ (base "192.168.1.2") ];
      services.nginx.enable = true;
      services.nginx.virtualHosts."my.website" = {
        root = pkgs.runCommand "testdir" {} ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';
      };
      services.nginx.virtualHosts."dummy-oidc" = {
        root = pkgs.runCommand "testdir" {} ''
          mkdir -p "$out/.well-known"
          cat <<EOF >"$out/.well-known/openid-configuration"
            {
              "issuer": "http://dummy-oidc",
              "authorization_endpoint": "http://dummy-oidc/auth.txt",
              "token_endpoint": "http://dummy-oidc/token",
              "jwks_uri": "http://dummy-oidc/jwks.json",
              "userinfo_endpoint": "http://dummy-oidc/userinfo",
              "id_token_signing_alg_values_supported": ["RS256"]
            }
          EOF
          echo hello I am login page >"$out/auth.txt"
        '';
      };
    };
  };

  testScript = { ... }: ''
    backend.wait_for_unit("nginx")
    backend.wait_for_open_port(80)

    pomerium.wait_for_unit("pomerium")
    pomerium.wait_for_open_port(80)

    with subtest("no authentication required"):
        pomerium.succeed(
            "curl --resolve my.website:80:127.0.0.1 http://my.website | grep 'hello world'"
        )

    with subtest("login required"):
        pomerium.succeed(
            "curl -I --resolve login.required:80:127.0.0.1 http://login.required | grep pom-auth"
        )
        pomerium.succeed(
            "curl -L --resolve login.required:80:127.0.0.1 http://login.required | grep 'hello I am login page'"
        )

    with subtest("ui"):
        pomerium.succeed(
          # check for a string that only appears if the UI is displayed correctly
            "chromium --no-sandbox --headless --disable-gpu --dump-dom --host-resolver-rules='MAP login.required 127.0.0.1:80' http://login.required/.pomerium | grep 'contact your administrator'"
        )
  '';
})
