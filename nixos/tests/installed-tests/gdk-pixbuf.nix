{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gdk-pixbuf;

  testConfig = {
    # Tests allocate a lot of memory trying to exploit a CVE
    # but qemu-system-i386 has a 2047M memory limit
    virtualisation.memorySize = if pkgs.stdenv.isi686 then 2047 else 4096;
  };

  testRunnerFlags = [ "--timeout" "1800" ];
}
