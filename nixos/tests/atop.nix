import ./make-test-python.nix ({ pkgs, ... }: {
  name = "atop";

  nodes = {
    defaults = { ... }: {
      programs.atop = {
        enable = true;
      };
    };
    minimal = { ... }: {
      programs.atop = {
        enable = true;
        atopsvc.enable = false;
        atopRotate.enable = false;
        atopacct.enable = false;
      };
    };
    minimal_with_setuid = { ... }: {
      programs.atop = {
        enable = true;
        atopsvc.enable = false;
        atopRotate.enable = false;
        atopacct.enable = false;
        setuidWrapper.enable = true;
      };
    };

    atoprc_and_netatop = { ... }: {
      programs.atop = {
        enable = true;
        netatop.enable = true;
        settings = {
          flags = "faf1";
          interval = 2;
        };
      };
    };

    atopgpu = { lib, ... }: {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "cudatoolkit"
      ];
      programs.atop = {
        enable = true;
        atopgpu.enable = true;
      };
    };
  };

  testScript = ''
    def a_version(m):
      v = m.succeed("atop -V")
      pkgver = "${pkgs.atop.version}"
      assert v.startswith("Version: {}".format(pkgver)), "Version is {}, expected `{}`".format(v, pkgver)

    def __exp_path(m, prg, expected):
      p = m.succeed("type -p \"{}\" | head -c -1".format(prg))
      assert p == expected, "{} is `{}`, expected `{}`".format(prg, p, expected)

    def a_setuid(m, present=True):
      if present:
        __exp_path(m, "atop", "/run/wrappers/bin/atop")
        stat = m.succeed("stat --printf '%a %u' /run/wrappers/bin/atop")
        assert stat == "4511 0", "Wrapper stat is {}, expected `4511 0`".format(stat)
      else:
        __exp_path(m, "atop", "/run/current-system/sw/bin/atop")

    def assert_no_netatop(m):
      m.require_unit_state("netatop.service", "inactive")
      m.fail("modprobe -n -v netatop")

    def a_netatop(m, present=True):
      m.require_unit_state("netatop.service", "active" if present else "inactive")
      if present:
        out = m.succeed("modprobe -n -v netatop")
        assert out == "", "Module should be loaded, but modprobe would have done `{}`.".format(out)
      else:
        m.fail("modprobe -n -v netatop")

    def a_atopgpu(m, present=True):
      m.require_unit_state("atopgpu.service", "active" if present else "inactive")
      if present:
        __exp_path(m, "atopgpud", "/run/current-system/sw/bin/atopgpud")

    # atop.service should log some data to /var/log/atop
    def a_atopsvc(m, present=True):
      m.require_unit_state("atop.service", "active" if present else "inactive")
      if present:
          files = int(m.succeed("ls -1 /var/log/atop | wc -l"))
          assert files >= 1, "Expected at least 1 data file"
        # def check_files(_):
        #   files = int(m.succeed("ls -1 /var/log/atop | wc -l"))
        #   return files >= 1
        # retry(check_files)

    def a_atoprotate(m, present=True):
      m.require_unit_state("atop-rotate.timer", "active" if present else "inactive")

    # atopacct.service should make kernel write to /run/pacct_source and make dir
    # /run/pacct_shadow.d
    def a_atopacct(m, present=True):
      m.require_unit_state("atopacct.service", "active" if present else "inactive")
      if present:
        m.succeed("test -f /run/pacct_source")
        files = int(m.succeed("ls -1 /run/pacct_shadow.d | wc -l"))
        assert files >= 1, "Expected at least 1 pacct_shadow.d file"

    def a_atoprc(m, contents):
      if contents:
        f = m.succeed("cat /etc/atoprc")
        assert f == contents, "/etc/atoprc contents: `{}`, expected `{}`".format(f, contents)
      else:
        m.succeed("test ! -e /etc/atoprc")

    def assert_all(m, setuid, atopsvc, atoprotate, atopacct, netatop, atopgpu, atoprc):
      a_version(m)
      a_setuid(m, setuid)
      a_atopsvc(m, atopsvc)
      a_atoprotate(m, atoprotate)
      a_atopacct(m, atopacct)
      a_netatop(m, netatop)
      a_atopgpu(m, atopgpu)
      a_atoprc(m, atoprc)

    assert_all(defaults, False, True, True, True, False, False, False)
    assert_all(minimal, False, False, False, False, False, False, False)
    assert_all(minimal_with_setuid, True, False, False, False, False, False, False)
    assert_all(atoprc_and_netatop, False, True, True, True, True, False,
      "flags faf1\ninterval 2\n")
    assert_all(atopgpu, False, True, True, True, False, True, False)
  '';
})
