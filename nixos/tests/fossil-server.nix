import ./make-test-python.nix ({ pkgs, ... }:

let
  hashes = pkgs.writeText "hashes" ''
    b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c  /project/bar
    181210f8f9c779c26da1d9b2075bde0127302ee0e3fca38c9a83f5b1dd8e5d3b  /project/123
  '';
in {
  name = "fossil-server";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ uthar ];
  };

  nodes = {
    server =
      { config, ... }: {
        environment.systemPackages = [ pkgs.fossil ];

        systemd.tmpfiles.rules = [
          # type path    mode user   group   age arg
          " d    /museum 0777 fossil fossil  -   -"
        ];

        services.fossil = {
          enable = true;
          repository = "/museum";
        };
      };

    client =
      { pkgs, ... }: {
        environment.systemPackages = [ pkgs.fossil ];
      };
  };

  testScript = ''
    start_all()

    with subtest("create project.fossil"):
        server.succeed(
            "fossil init /museum/project.fossil",
            "fossil user new hacker hacker@example.org 123456 -R /museum/project.fossil",
            "fossil user capabilites hacker uv -R /museum/project.fossil",
            "chown fossil:fossil /museum/project.fossil",
        )

    with subtest("add file to project.fossil"):
        server.succeed(
            "fossil open /museum/project.fossil --workdir /project",
            "echo foo > /project/bar",
            "(cd /project && fossil add bar)",
            "(cd /project && fossil commit -m quux)",
        )

    with subtest("fossil daemon starts"):
        server.wait_for_unit("fossil.service")

    server.wait_for_unit("network-online.target")
    client.wait_for_unit("network-online.target")

    with subtest("client can clone project.fossil"):
        client.succeed(
            "fossil clone --save-http-password http://hacker:123456@server:8080/project",
            "fossil open project.fossil --workdir /project",
            "echo 123 > /project/123",
            "sha256sum -c ${hashes}",
        )

    with subtest("client can commit to fossil server"):
        client.succeed(
            "(cd /project && fossil add 123)",
            "(cd /project && fossil commit -m 123)",
        )

    with subtest("pushed file is there on server"):
        server.succeed(
           "(cd /project && fossil update)",
           "sha256sum -c ${hashes}",
        )

  '';
})
