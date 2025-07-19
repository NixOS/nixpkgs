{ pkgs, ... }:
let
  tls_chain = "${./common/acme/server}/ca.cert.pem";
  tls_key = "${./common/acme/server}/ca.key.pem";
in
{
  name = "netbird";

  meta.maintainers = with pkgs.lib.maintainers; [
    patrickdag
    nazarewk
  ];

  nodes = {
    clients =
      { ... }:
      {
        services.netbird.enable = true;
        services.netbird.clients.custom.port = 51819;
      };
    kanidm = {
      services.kanidm = {
        # needed since default for nixos 24.11
        # is kanidm 1.4.6 which is insecure
        package = pkgs.kanidm_1_5;
        enableServer = true;
        serverSettings = {
          inherit tls_key tls_chain;
          domain = "localhost";
          origin = "https://localhost";
        };
      };
    };
    server =
      { ... }:
      {
        # netbirds needs an openid identity provider
        services.netbird.server = {
          enable = true;
          coturn = {
            enable = true;
            coturn = {
              enable = true;
              password = "secure-password";
            };
            domain = "nixos-test.internal";
            dashboard.settings.AUTH_AUTHORITY = "https://kanidm/oauth2/openid/netbird";
            management.oidcConfigEndpoint = "https://kanidm:8443/oauth2/openid/netbird/.well-known/openid-configuration";
            relay.authSecretFile = (pkgs.writeText "secure-secret" "secret-value");
          };
          domain = "nixos-test.internal";
          dashboard.settings.AUTH_AUTHORITY = "https://kanidm/oauth2/openid/netbird";
          management.oidcConfigEndpoint = "https://kanidm:8443/oauth2/openid/netbird/.well-known/openid-configuration";
        };
      };
  };

  # TODO: confirm the whole solution is working end-to-end when netbird server is implemented
  testScript = ''
    start_all()
    def did_start(node, name, interval=0.5, timeout=10):
      node.wait_for_unit(f"{name}.service")
      node.wait_for_file(f"/var/run/{name}/sock")
      # `netbird status` returns a full "Disconnected" status during initialization
      # only after a while passes it starts returning "NeedsLogin" help message

      start = time.time()
      output = node.succeed(f"{name} status")
      while "Disconnected" in output and (time.time() - start) < timeout:
        time.sleep(interval)
        output = node.succeed(f"{name} status")
      assert "NeedsLogin" in output

       did_start(clients, "netbird")
       did_start(clients, "netbird-custom")

      kanidm.start()
      kanidm.wait_for_unit("kanidm.service")

      server.start()
      with subtest("server starting"):
        server.wait_for_unit("netbird-management.service")
        server.wait_for_unit("netbird-signal.service")
        server.wait_for_unit("netbird-relay.service")
  '';
}
