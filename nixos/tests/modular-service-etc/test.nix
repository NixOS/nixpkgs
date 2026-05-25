# Run with:
#   cd nixpkgs
#   nix-build -A nixosTests.modular-service-etc

# This tests the NixOS modular service integration to make sure `etc` entries
# are generated correctly for `configData` files.
{ lib, ... }:
{
  _class = "nixosTest";
  name = "modular-service-etc";

  nodes = {
    server =
      { pkgs, ... }:
      let
        # Normally the package services.default attribute combines this, but we
        # don't have that, because this is not a production service. Should it be?
        python-http-server = {
          imports = [ ./python-http-server.nix ];
          python-http-server.package = pkgs.python3;
        };
      in
      {
        system.services.webserver = {
          # The python web server is simple enough that it doesn't need a reload signal.
          # Other services may need to receive a signal in order to re-read what's in `configData`.
          imports = [ python-http-server ];
          python-http-server = {
            port = 8080;
          };

          configData = {
            "webroot" = {
              source = pkgs.runCommand "webroot" { } ''
                mkdir -p $out
                cat > $out/index.html << 'EOF'
                <!DOCTYPE html>
                <html>
                <head><title>Python Web Server</title></head>
                <body>
                  <h1>Welcome to the Python Web Server</h1>
                  <p>Serving from port 8080</p>
                </body>
                </html>
                EOF
              '';
            };
          };

          # Add a sub-service
          services.api = {
            imports = [ python-http-server ];
            python-http-server = {
              port = 8081;
            };
            configData = {
              "webroot" = {
                source = pkgs.runCommand "api-webroot" { } ''
                  mkdir -p $out
                  cat > $out/index.html << 'EOF'
                  <!DOCTYPE html>
                  <html>
                  <head><title>API Sub-service</title></head>
                  <body>
                    <h1>API Sub-service</h1>
                    <p>This is a sub-service running on port 8081</p>
                  </body>
                  </html>
                  EOF
                  cat > $out/status.json << 'EOF'
                  {"status": "ok", "service": "api", "port": 8081}
                  EOF
                '';
              };
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          8080
          8081
        ];

        specialisation.updated.configuration = {
          system.services.webserver = {
            configData = {
              "webroot" = {
                source = lib.mkForce (
                  pkgs.runCommand "webroot-updated" { } ''
                    mkdir -p $out
                    cat > $out/index.html << 'EOF'
                    <!DOCTYPE html>
                    <html>
                    <head><title>Updated Python Web Server</title></head>
                    <body>
                      <h1>Updated content via specialisation</h1>
                      <p>This content was changed without restarting the service</p>
                    </body>
                    </html>
                    EOF
                  ''
                );
              };
            };

            services.api = {
              configData = {
                "webroot" = {
                  source = lib.mkForce (
                    pkgs.runCommand "api-webroot-updated" { } ''
                      mkdir -p $out
                      cat > $out/index.html << 'EOF'
                      <!DOCTYPE html>
                      <html>
                      <head><title>Updated API Sub-service</title></head>
                      <body>
                        <h1>Updated API Sub-service</h1>
                        <p>This sub-service content was also updated</p>
                      </body>
                      </html>
                      EOF
                      cat > $out/status.json << 'EOF'
                      {"status": "updated", "service": "api", "port": 8081, "version": "2.0"}
                      EOF
                    ''
                  );
                };
              };
            };
          };
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    # Wait for the web servers to start
    server.wait_for_unit("webserver.service")
    server.wait_for_open_port(8080)
    server.wait_for_unit("webserver-api.service")
    server.wait_for_open_port(8081)

    # Check that the configData directories were created with unique paths
    server.succeed("test -d /etc/system-services/webserver/webroot")
    server.succeed("test -f /etc/system-services/webserver/webroot/index.html")
    server.succeed("test -d /etc/system-services/webserver-api/webroot")
    server.succeed("test -f /etc/system-services/webserver-api/webroot/index.html")
    server.succeed("test -f /etc/system-services/webserver-api/webroot/status.json")

    # Check that the main web server is serving the configData content
    client.succeed("curl -f http://server:8080/index.html | grep 'Welcome to the Python Web Server'")
    client.succeed("curl -f http://server:8080/index.html | grep 'Serving from port 8080'")

    # Check that the sub-service is serving its own configData content
    client.succeed("curl -f http://server:8081/index.html | grep 'API Sub-service'")
    client.succeed("curl -f http://server:8081/index.html | grep 'This is a sub-service running on port 8081'")
    client.succeed("curl -f http://server:8081/status.json | grep '\"service\": \"api\"'")

    # Record PIDs before switching to verify services aren't restarted
    webserver_pid = server.succeed("systemctl show webserver.service --property=MainPID --value").strip()
    api_pid = server.succeed("systemctl show webserver-api.service --property=MainPID --value").strip()

    print(f"Before switch - webserver PID: {webserver_pid}, api PID: {api_pid}")

    # Switch to the specialisation with updated content
    # Capture both stdout and stderr, and show stderr in real-time for debugging
    switch_output = server.succeed("/run/current-system/specialisation/updated/bin/switch-to-configuration test 2>&1 | tee /dev/stderr")
    print(f"Switch output (stdout+stderr): {switch_output}")

    # Verify services are not mentioned in the switch output (indicating they weren't touched)
    assert "webserver.service" not in switch_output, f"webserver.service was mentioned in switch output: {switch_output}"
    assert "webserver-api.service" not in switch_output, f"webserver-api.service was mentioned in switch output: {switch_output}"

    # Verify the content was updated without restarting the services
    server.succeed("systemctl is-active webserver.service")
    server.succeed("systemctl is-active webserver-api.service")

    # Verify PIDs are the same (services weren't restarted)
    webserver_pid_after = server.succeed("systemctl show webserver.service --property=MainPID --value").strip()
    api_pid_after = server.succeed("systemctl show webserver-api.service --property=MainPID --value").strip()

    print(f"After switch - webserver PID: {webserver_pid_after}, api PID: {api_pid_after}")

    assert webserver_pid == webserver_pid_after, f"webserver.service was restarted: PID changed from {webserver_pid} to {webserver_pid_after}"
    assert api_pid == api_pid_after, f"webserver-api.service was restarted: PID changed from {api_pid} to {api_pid_after}"

    # Check main service updated content
    client.succeed("curl -f http://server:8080/index.html | grep 'Updated content via specialisation'")
    client.succeed("curl -f http://server:8080/index.html | grep 'This content was changed without restarting the service'")

    # Check sub-service updated content
    client.succeed("curl -f http://server:8081/index.html | grep 'Updated API Sub-service'")
    client.succeed("curl -f http://server:8081/index.html | grep 'This sub-service content was also updated'")
    client.succeed("curl -f http://server:8081/status.json | grep '\"version\": \"2.0\"'")
  '';

  meta.maintainers = with lib.maintainers; [ roberth ];
}
