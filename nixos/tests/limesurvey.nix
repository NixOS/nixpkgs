import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "limesurvey";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes.machine = { ... }: {
    services.limesurvey = {
      enable = true;
      virtualHost = {
        hostName = "example.local";
        adminAddr = "root@example.local";
      };
      encryptionKeyFile = pkgs.writeText "key" (lib.strings.replicate 32 "0");
      encryptionNonceFile = pkgs.writeText "nonce" (lib.strings.replicate 24 "0");
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
