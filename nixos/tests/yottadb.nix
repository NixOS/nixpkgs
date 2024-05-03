import ./make-test-python.nix ({ pkgs, ...} :
let
  ydbWithAsan = pkgs.yottadb.overrideAttrs (_prev: {
    enableAsan = true;
  });
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
  testJnl = "/tmp/test.mjl";
in {
  name = "yottadb";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ztmr ];
  };

  nodes = {
    ydbvm = { pkgs, ... }: {
      programs.yottadb = {
        enable = true;
        package = ydbWithAsan;
      };
      environment = {
        systemPackages = [ ydbWithAsan pkgs.lsof ];
        variables = {
          ydb_routines = "${ydbWithAsan}/lib/libyottadbutil-utf8.so /tmp/";
          ydb_gbldir = "/tmp/ydbtest.gld";
          ydb_dist = "${ydbWithAsan}/dist";
          ASAN_OPTIONS = ydbWithAsan.asanOptions;
        };
      };
    };
  };

  testScript = ''
    from datetime import datetime

    start_all()

    ydbvm.succeed("gde @${ydbTestGde}")
    ydbvm.succeed("mupip create")
    ydbvm.succeed("cp ${ydbTestRtn} /tmp/ydbTest.m")
    ydbvm.succeed("yottadb -r checkProcName^ydbTest")
    ydbvm.succeed("yottadb -r writeDb^ydbTest")

    ydbvm.succeed("test $(stat -L -c %a ${ydbWithAsan.ydbSecRunDir}/gtmsecshr) -eq 4555")
    ydbvm.succeed("test $(stat -L -c %a ${ydbWithAsan.ydbSecRunDir}/gtmsecshrdir) -eq 0500")
    ydbvm.succeed("test $(stat -L -c %a ${ydbWithAsan.ydbSecRunDir}/gtmsecshrdir/gtmsecshr) -eq 4500")

    def getSyslogTs():
      _ts = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")
      # For some reason, utcnow gives ~1.5s more than journalctl timestamp
      ydbvm.succeed("sleep 2")
      return _ts

    # Test manual `gtmsecshr` start using full absolute path
    ts = getSyslogTs()
    ydbvm.succeed("${ydbWithAsan.ydbSecRunDir}/gtmsecshr")
    ydbvm.fail("journalctl --no-pager -S '%s' -g 'E-SECSHR'" % ts)
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-GTMSECSHRDMNSTARTED'" % ts)
    ydbvm.succeed("ls -la ${ydbWithAsan.ydbSecRunDir}/gtmsecshrdir/")
    ydbvm.succeed("lsof -p \"$(pgrep gtmsecshr)\" | grep /ydb_secshr")
    ydbvm.succeed("test -S /tmp/ydb_secshr$(journalctl --no-pager -S '%s' -g 'I-GTMSECSHRDMNSTARTED' | sed 's,.*key: 0x\\([0-9A-F]*\\)).*,\\1,g')" % ts)

    ts = getSyslogTs()
    ydbvm.succeed("yottadb -r checkHelp^ydbTest")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'DATA-ON-HELP=11'" % ts)

    ts = getSyslogTs()
    ydbvm.succeed("mupip extend -b=1024 DEFAULT")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-DBFILEXT'" % ts)
    ydbvm.succeed("mupip reorg -region DEFAULT -fill_factor=100 -index_fill_factor=100 -truncate")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-MUTRUNCSUCCESS'" % ts)
    integLog = "/tmp/mupip-integ.log"
    ydbvm.succeed("mupip integ -region DEFAULT 2>&1 | tee %s" % integLog)
    ydbvm.succeed("grep -q 'No errors detected' %s" % integLog)

    ts = getSyslogTs()
    ydbvm.succeed("mupip stop 0$(pgrep gtmsecshr)")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-MUPIPSIG, STOP'" % ts)
    ydbvm.fail("pgrep gtmsecshr")

    # Test automatic `gtmsecshr` start and correct operation
    ts = getSyslogTs()
    ydbvm.succeed("mupip set -journal=enable,on,before,fi=${testJnl} -reg DEFAULT")
    ydbvm.succeed("yottadb -r writeDb^ydbTest")
    ydbvm.succeed("mupip journal -extract -noverify -detail -forward -fences=none ${testJnl}")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-GTMSECSHRDMNSTARTED'" % ts)
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-GTMSECSHRUPDDBHDR'" % ts)
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'updated for open'" % ts)
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'updated for close'" % ts)
    ydbvm.succeed("mupip stop 0$(pgrep gtmsecshr)")
    ydbvm.succeed("journalctl --no-pager -S '%s' -g 'I-MUPIPSIG, STOP'" % ts)
    ydbvm.fail("pgrep gtmsecshr")

    ydbvm.shutdown()
  '';
})
