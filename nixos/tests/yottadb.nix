import ./make-test-python.nix ({ pkgs, ...} :
let
    ydbTestRtn = pkgs.writeText "ydbTest.m" ''
      ydbTest
        D ^%FREECNT
        N I F I=0:1:100 S ^ydbTest(I)=$J
        ZHALT $S($G(^ydbTest($R(100)))=$J:0,1:127)
    '';
    ydbTestGde = pkgs.writeText "ydbtest.gde" ''
      C -S DEFAULT -F=/tmp/ydbtest.dat
      VER
      SH
      EX
    '';
in {
  name = "yottadb";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ztmr ];
  };

  nodes = {
    machine = { pkgs, ... }: {
      programs.yottadb.enable = true;
      environment = {
        systemPackages = [ pkgs.yottadb ];
        variables = {
          ydb_routines = "${pkgs.yottadb}/lib/libyottadbutil-utf8.so /tmp/";
          ydb_gbldir = "/tmp/ydbtest.gld";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.succeed("gde @${ydbTestGde}")
    machine.succeed("mupip create")
    machine.succeed("cp ${ydbTestRtn} /tmp/ydbTest.m")
    machine.succeed("yottadb -r ^ydbTest")

    machine.shutdown()
  '';
})
