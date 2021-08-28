{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let assertions = rec {
  path = program: path: ''
    with subtest("The path of ${program} should be ${path}"):
        p = machine.succeed("type -p \"${program}\" | head -c -1")
        assert p == "${path}", f"${program} is {p}, expected ${path}"
  '';
  unit = name: state: ''
    with subtest("Unit ${name} should be ${state}"):
        machine.require_unit_state("${name}", "${state}")
  '';
  version = ''
    import re

    with subtest("binary should report the correct version"):
        pkgver = "${pkgs.atop.version}"
        ver = re.sub(r'(?s)^Version: (\d\.\d\.\d).*', r'\1', machine.succeed("atop -V"))
        assert ver == pkgver, f"Version is `{ver}`, expected `{pkgver}`"
  '';
  atoprc = contents:
    if builtins.stringLength contents > 0 then ''
      with subtest("/etc/atoprc should have the correct contents"):
          f = machine.succeed("cat /etc/atoprc")
          assert f == "${contents}", f"/etc/atoprc contents: '{f}', expected '${contents}'"
    '' else ''
      with subtest("/etc/atoprc should not be present"):
          machine.succeed("test ! -e /etc/atoprc")
    '';
  wrapper = present:
    if present then path "atop" "/run/wrappers/bin/atop" + ''
      with subtest("Wrapper should be setuid root"):
          stat = machine.succeed("stat --printf '%a %u' /run/wrappers/bin/atop")
          assert stat == "4511 0", f"Wrapper stat is {stat}, expected '4511 0'"
    ''
    else path "atop" "/run/current-system/sw/bin/atop";
  atopService = present:
    if present then
      unit "atop.service" "active"
      + ''
        with subtest("atop.service should have written some data to /var/log/atop"):
            files = int(machine.succeed("ls -1 /var/log/atop | wc -l"))
            assert files > 0, "Expected at least 1 data file"
      '' else unit "atop.service" "inactive";
  atopRotateTimer = present:
    unit "atop-rotate.timer" (if present then "active" else "inactive");
  atopacctService = present:
    if present then
      unit "atopacct.service" "active"
      + ''
        with subtest("atopacct.service should enable process accounting"):
            machine.succeed("test -f /run/pacct_source")

        with subtest("atopacct.service should write data to /run/pacct_shadow.d"):
            files = int(machine.succeed("ls -1 /run/pacct_shadow.d | wc -l"))
            assert files >= 1, "Expected at least 1 pacct_shadow.d file"
      '' else unit "atopacct.service" "inactive";
  netatop = present:
    if present then
      unit "netatop.service" "active"
      + ''
        with subtest("The netatop kernel module should be loaded"):
            out = machine.succeed("modprobe -n -v netatop")
            assert out == "", f"Module should be loaded already, but modprobe would have done {out}."
      '' else ''
      with subtest("The netatop kernel module should be absent"):
          machine.fail("modprobe -n -v netatop")
    '';
  atopgpu = present:
    if present then
      (unit "atopgpu.service" "active") + (path "atopgpud" "/run/current-system/sw/bin/atopgpud")
    else (unit "atopgpu.service" "inactive") + ''
      with subtest("atopgpud should not be present"):
          machine.fail("type -p atopgpud")
    '';
};
in
{
  name = "atop";

  justThePackage = makeTest {
    name = "atop-justThePackage";
    machine = {
      environment.systemPackages = [ pkgs.atop ];
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "")
      (wrapper false)
      (atopService false)
      (atopRotateTimer false)
      (atopacctService false)
      (netatop false)
      (atopgpu false)
    ];
  };
  defaults = makeTest {
    name = "atop-defaults";
    machine = {
      programs.atop = {
        enable = true;
      };
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "")
      (wrapper false)
      (atopService true)
      (atopRotateTimer true)
      (atopacctService true)
      (netatop false)
      (atopgpu false)
    ];
  };
  minimal = makeTest {
    name = "atop-minimal";
    machine = {
      programs.atop = {
        enable = true;
        atopService.enable = false;
        atopRotateTimer.enable = false;
        atopacctService.enable = false;
      };
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "")
      (wrapper false)
      (atopService false)
      (atopRotateTimer false)
      (atopacctService false)
      (netatop false)
      (atopgpu false)
    ];
  };
  netatop = makeTest {
    name = "atop-netatop";
    machine = {
      programs.atop = {
        enable = true;
        netatop.enable = true;
      };
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "")
      (wrapper false)
      (atopService true)
      (atopRotateTimer true)
      (atopacctService true)
      (netatop true)
      (atopgpu false)
    ];
  };
  atopgpu = makeTest {
    name = "atop-atopgpu";
    machine = {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
        "cudatoolkit"
      ];

      programs.atop = {
        enable = true;
        atopgpu.enable = true;
      };
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "")
      (wrapper false)
      (atopService true)
      (atopRotateTimer true)
      (atopacctService true)
      (netatop false)
      (atopgpu true)
    ];
  };
  everything = makeTest {
    name = "atop-everthing";
    machine = {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
        "cudatoolkit"
      ];

      programs.atop = {
        enable = true;
        settings = {
          flags = "faf1";
          interval = 2;
        };
        setuidWrapper.enable = true;
        netatop.enable = true;
        atopgpu.enable = true;
      };
    };
    testScript = with assertions; builtins.concatStringsSep "\n" [
      version
      (atoprc "flags faf1\\ninterval 2\\n")
      (wrapper true)
      (atopService true)
      (atopRotateTimer true)
      (atopacctService true)
      (netatop true)
      (atopgpu true)
    ];
  };
}
