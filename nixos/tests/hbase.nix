import ./make-test-python.nix (
  {
    pkgs,
    lib,
    package ? pkgs.hbase,
    ...
  }:
  {
    name = "hbase-standalone";

    meta = with lib.maintainers; {
      maintainers = [ illustris ];
    };

    nodes = {
      hbase =
        { pkgs, ... }:
        {
          services.hbase-standalone = {
            enable = true;
            inherit package;
            # Needed for standalone mode in hbase 2+
            # This setting and standalone mode are not suitable for production
            settings."hbase.unsafe.stream.capability.enforce" = "false";
          };
          environment.systemPackages = with pkgs; [
            package
          ];
        };
    };

    testScript = ''
      start_all()
      hbase.wait_for_unit("hbase.service")
      hbase.wait_until_succeeds("echo \"create 't1','f1'\" | sudo -u hbase hbase shell -n")
      assert "NAME => 'f1'" in hbase.succeed("echo \"describe 't1'\" | sudo -u hbase hbase shell -n")
    '';
  }
)
