import ./make-test-python.nix ({ pkgs, ... }: {
  name = "limesurvey";
  meta.maintainers = [ pkgs.lib.maintainers.aanderse ];

  nodes.machine = { ... }: {
    services.limesurvey = {
      enable = true;
      virtualHost = {
        hostName = "example.local";
        adminAddr = "root@example.local";
      };
    };

    # limesurvey won't work without a dot in the hostname
    networking.hosts."127.0.0.1" = [ "example.local" ];
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("phpfpm-limesurvey.service")
    assert "The following surveys are available" in machine.succeed(
        "curl -f http://example.local/"
    )
  '';
})
