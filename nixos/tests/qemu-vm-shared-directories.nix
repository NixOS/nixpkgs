{
  config,
  lib,
  pkgs,
  ...
}:
{
  name = "qemu-vm-shared-directories";

  meta.maintainers = [ ];

  nodes = lib.listToAttrs (
    map
      (policy: {
        name = policy;
        value.virtualisation.sharedDirectories.test = {
          source = "/tmp/${policy}";
          target = "/mnt/test";
          cache = policy;
          writable = true;
        };
      })
      [
        "never"
        "metadata"
        "auto"
        "always"
      ]
  );

  testScript =
    let
      pgrep = lib.getExe' pkgs.procps "pgrep";
    in
    ''
      import os, subprocess

      for policy in ${with builtins; toJSON (attrNames config.nodes)}:
          os.makedirs(f"/tmp/{policy}", exist_ok=True)
          with open(f"/tmp/{policy}/hello.txt", "w") as f:
              f.write("before")

      start_all()

      virtiofsd_procs = subprocess.check_output(["${pgrep}", "-af", "virtiofsd"]).decode()

      with subtest("virtiofsd is invoked with the correct --cache flag for each policy"):
          for policy in ${with builtins; toJSON (attrNames config.nodes)}:
              assert f"--cache={policy}" in virtiofsd_procs, \
                  f"--cache={policy} not found in virtiofsd processes"

      for machine, policy in [(never, "never"), (metadata, "metadata")]:
          with subtest(f"host changes are immediately visible with cache={policy}"):
              machine.succeed("grep before /mnt/test/hello.txt")
              with open(f"/tmp/{policy}/hello.txt", "w") as f:
                  f.write("after")
              machine.succeed("grep after /mnt/test/hello.txt")

      with subtest("host changes are visible on reopen with cache=auto"):
          auto.succeed("grep before /mnt/test/hello.txt")
          with open("/tmp/auto/hello.txt", "w") as f:
              f.write("after")
          auto.succeed("grep after /mnt/test/hello.txt")

      with subtest("host changes are not visible with cache=always"):
          always.succeed("grep before /mnt/test/hello.txt")
          with open("/tmp/always/hello.txt", "w") as f:
              f.write("after")
          always.succeed("grep before /mnt/test/hello.txt")
    '';

}
