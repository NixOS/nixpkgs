{ pkgs, lib, ... }:
{
  name = "docuum";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers.machine = {
    virtualisation.docker.enable = true;

    services.docuum = {
      enable = true;
      threshold = "5 MB";
      keep = [ "^keep-me:" ];
    };
  };

  testScript =
    let
      # Each image is 2 MB, so the third non-exempt image should be evicted.
      imageSizeKb = 2 * 1024;

      mkTestImage =
        name:
        pkgs.dockerTools.buildImage {
          inherit name;
          tag = "test";
          copyToRoot = pkgs.runCommand "docuum-test-data-${name}" { } ''
            mkdir -p $out
            echo "${name}" > $out/name
            dd if=/dev/zero of=$out/data bs=1024 count=${toString imageSizeKb}
          '';
        };

      images = {
        keepMe = mkTestImage "keep-me";
        old = mkTestImage "old-image";
        new = mkTestImage "new-image";
      };
    in
    ''
      start_all()

      machine.wait_for_unit("docker.service")
      machine.wait_for_unit("docuum.service")
      machine.wait_until_succeeds("journalctl -u docuum --grep 'Listening for Docker events'")

      machine.succeed(
          "docker load < ${images.keepMe}",
          "docker load < ${images.old}",
          "docker load < ${images.new}",
      )

      machine.wait_until_fails("docker image inspect old-image:test")
      machine.succeed(
          "docker image inspect keep-me:test",
          "docker image inspect new-image:test",
      )
    '';
}
