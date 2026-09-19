{
  config,
  lib,
  pkgs,
  ...
}:
{
  name = "qemu-vm-shared-directories";

  meta.maintainers = with lib.maintainers; [
    fricklerhandwerk
  ];

  meta.platforms = lib.platforms.linux;

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

      for machine, policy in [${
        lib.concatMapStringsSep ", " (p: ''(${p}, "${p}")'') (builtins.attrNames config.nodes)
      }]:
          with subtest(f"cache={policy} propagates host file changes to the guest as expected"):
              machine.succeed("grep before /mnt/test/hello.txt")
              with open(f"/tmp/{policy}/hello.txt", "w") as f:
                  f.write("after")
              if policy == "always":
                  always.succeed("grep before /mnt/test/hello.txt")
              else:
                  machine.succeed("grep after /mnt/test/hello.txt")
    '';
}
