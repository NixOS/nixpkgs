import ./make-test-python.nix ({ lib, ... }: {
  name = "silverbullet";
  meta.maintainers = with lib.maintainers; [ aorith ];

  nodes.simple = { ... }: {
    services.silverbullet.enable = true;
  };

  nodes.configured = { pkgs, ... }: {
    users.users.test.isNormalUser = true;
    users.groups.test = { };

    services.silverbullet = {
      enable = true;
      package = pkgs.silverbullet;
      listenPort = 3001;
      listenAddress = "localhost";
      spaceDir = "/home/test/silverbullet";
      user = "test";
      group = "test";
      envFile = pkgs.writeText "silverbullet.env" ''
        SB_USER=user:password
        SB_AUTH_TOKEN=test
      '';
      extraArgs = [ "--reindex" "--db /home/test/silverbullet/custom.db" ];
    };
  };

  testScript = { nodes, ... }: ''
    PORT = ${builtins.toString nodes.simple.services.silverbullet.listenPort}
    ADDRESS = "${nodes.simple.services.silverbullet.listenAddress}"
    SPACEDIR = "${nodes.simple.services.silverbullet.spaceDir}"
    simple.wait_for_unit("silverbullet.service")
    simple.wait_for_open_port(PORT)
    simple.succeed(f"curl --max-time 5 -s -v -o /dev/null --fail http://{ADDRESS}:{PORT}/")
    simple.succeed(f"test -d '{SPACEDIR}'")

    PORT = ${builtins.toString nodes.configured.services.silverbullet.listenPort}
    ADDRESS = "${nodes.configured.services.silverbullet.listenAddress}"
    SPACEDIR = "${nodes.configured.services.silverbullet.spaceDir}"
    configured.wait_for_unit("silverbullet.service")
    configured.wait_for_open_port(PORT)
    assert int(configured.succeed(f"curl --max-time 5 -s -o /dev/null -w '%{{http_code}}' -XPUT -d 'test' --fail http://{ADDRESS}:{PORT}/test.md -H'Authorization: Bearer test'")) == 200
    assert int(configured.fail(f"curl --max-time 5 -s -o /dev/null -w '%{{http_code}}' -XPUT -d 'test' --fail http://{ADDRESS}:{PORT}/test.md -H'Authorization: Bearer wrong'")) == 401
    configured.succeed(f"test -d '{SPACEDIR}'")
  '';
})
