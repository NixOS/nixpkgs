import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "wordfence-cli";
    meta.maintainers = with lib.maintainers; [ am-on ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          wordfence-cli
        ];

      };

    testScript = ''
      start_all()

      output = machine.succeed("wordfence --version")
      assert "PCRE Supported: Yes" in output
      assert "Vectorscan Supported: Yes" in output
    '';
  }
)
