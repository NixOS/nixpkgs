import ./make-test-python.nix ({ pkgs, ...} :
let
    ydbTestRtn = pkgs.writeText "ydbTest.m" ''
      writeDb N I F I=0:1:100 S ^ydbTest(I)=$J
        ZHALT $G(^ydbTest($R(100)))'=$J
      checkProcName N F,X S F="/proc/self/comm" O F U F R X U 0 C F
        ZHALT X'="yottadb"
      checkHelp
        ; gtmhelp is readonly (Nix store), but why can't we just read it?
        ; Let's move gtmhelp to /tmp for our tests:
        ZSY "cp $ydb_dist/gtmhelp.* /tmp/"
        ; And update `gld` to point to a new `dat` copy:
        ZSY "env ydb_gbldir=/tmp/gtmhelp.gld $ydb_dist/gde change -segment DEFAULT -file=/tmp/gtmhelp.dat"
        ;
        S $zgbldir="/tmp/gtmhelp.gld"
        I $ZSYSLOG("DATA-ON-HELP="_$D(^HELP))
        ZHALT $O(^HELP(""))'="s"
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
          ydb_dist = "${pkgs.yottadb}/dist";
        };
      };
    };
  };

  testScript = ''
    from datetime import datetime

    start_all()

    machine.succeed("gde @${ydbTestGde}")
    machine.succeed("mupip create")
    machine.succeed("cp ${ydbTestRtn} /tmp/ydbTest.m")
    machine.succeed("yottadb -r checkProcName^ydbTest")
    machine.succeed("yottadb -r writeDb^ydbTest")

    #machine.succeed("test $(stat -L -c %a $ydb_dist/gtmsecshrdir) -eq 500")
    #machine.succeed("test $(stat -L -c %a $ydb_dist/utf8/gtmsecshrdir) -eq 500")

    def getSyslogTs():
      _ts = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")
      # For some reason, utcnow gives ~1.5s more than journalctl timestamp
      machine.succeed("sleep 2")
      return _ts

    ts = getSyslogTs()
    machine.succeed("$ydb_dist/gtmsecshr STOP")
    machine.fail("journalctl --no-pager -S '%s' -g 'E-SECSHR'" % ts)
    machine.succeed("journalctl --no-pager -S '%s' -g 'I-GTMSECSHRDMNSTARTED'" % ts)

    ts = getSyslogTs()
    machine.succeed("yottadb -r checkHelp^ydbTest")
    machine.succeed("journalctl --no-pager -S '%s' -g 'DATA-ON-HELP=11'" % ts)

    ts = getSyslogTs()
    machine.succeed("mupip extend -b=1024 DEFAULT")
    machine.succeed("journalctl --no-pager -S '%s' -g 'I-DBFILEXT'" % ts)
    machine.succeed("mupip reorg -region DEFAULT -fill_factor=100 -index_fill_factor=100 -truncate")
    machine.succeed("journalctl --no-pager -S '%s' -g 'I-MUTRUNCSUCCESS'" % ts)
    integLog = "/tmp/mupip-integ.log"
    machine.succeed("mupip integ -region DEFAULT 2>&1 | tee %s" % integLog)
    machine.succeed("grep -q 'No errors detected' %s" % integLog)

    # NOTE: gtmsecshr blocks shutdown for some reason, and killing it
    # makes the test vm shutdown faster...
    machine.succeed("pkill gtmsecshr")

    machine.shutdown()
  '';
})
