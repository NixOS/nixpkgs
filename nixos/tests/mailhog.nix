import ./make-test-python.nix ({ lib, ... }: {
  name = "mailhog";
  meta.maintainers = with lib.maintainers; [ jojosch ];

  machine = { pkgs, ... }: {
    services.mailhog.enable = true;

    environment.systemPackages = with pkgs; [ swaks ];
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("mailhog.service")
    machine.wait_for_open_port("1025")
    machine.wait_for_open_port("8025")
    machine.succeed(
        'echo "this is the body of the email" | swaks --to root@example.org --body - --server localhost:1025'
    )
    assert "this is the body of the email" in machine.succeed(
        "curl --fail http://localhost:8025/api/v2/messages"
    )
  '';
})
