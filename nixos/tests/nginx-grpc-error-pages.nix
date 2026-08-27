{ ... }:
{
  name = "nginx-grpc-error-pages";

  containers = {
    webserver =
      { pkgs, ... }:
      {
        services.nginx = {
          enable = true;

          virtualHosts.test = {
            locations = {
              "=/".return = "200 blub";
              "/grpc.reflection.v1.ServerReflection" = {
                useGrpcErrorPages = true;
                extraConfig = ''
                  grpc_pass unix:/run/some-service.sock;
                  # Let's pretend there was a more sophisticated check here
                  return 401;
                '';
              };
            };
          };
        };
      };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    # regular HTTP requests should behave normally
    webserver.succeed("curl --fail http://localhost")
    t.assertEqual(webserver.succeed("curl -s -o /dev/null -w '%{http_code}' http://localhost/404").strip(), "404")

    # a gRPC 401 becomes HTTP code 2xx, with grpc-message and grpc-status headers set.
    t.assertEqual(webserver.succeed("curl -s -o /dev/null --fail -w '%header{grpc-status}_%header{grpc-message}' http://localhost/grpc.reflection.v1.ServerReflection").strip(), "16_unauthenticated")
  '';
}
