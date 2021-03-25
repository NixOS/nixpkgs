import ./make-test-python.nix ({ pkgs, ...} : {
  name = "awscli";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.awscli ];
    };

  testScript =
    ''
      assert "${pkgs.python3Packages.botocore.version}" in machine.succeed("aws --version")
      assert "${pkgs.awscli.version}" in machine.succeed("aws --version")
    '';
})
