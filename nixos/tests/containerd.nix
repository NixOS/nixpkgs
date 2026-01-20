{ lib, pkgs, ... }:

let
  # Create passwd file
  etcFiles = pkgs.runCommand "containerd-symlink-passwd" { } ''
        mkdir -p $out/etc
        cat > $out/etc/passwd <<'EOF'
    root:x:0:0:root:/root:/bin/sh
    testuser:x:1000:0:test user:/home/testuser:/bin/sh
    EOF
  '';

  passwdSymlinkImage = pkgs.dockerTools.buildLayeredImage {
    name = "nixos-symlink-passwd-test";
    tag = "latest";

    contents = [
      pkgs.busybox
      etcFiles
    ];

    extraCommands = ''
      mkdir -p etc home/testuser
      rm -f etc/passwd
      ln -sf ${etcFiles}/etc/passwd etc/passwd
      test -L etc/passwd
    '';

    config = {
      # Forces containerd to read /etc/passwd in the rootfs
      User = "testuser";
      Cmd = [
        "/bin/sh"
        "-lc"
        "id -u; echo OK"
      ];
    };
  };
in
{
  name = "containerd";
  meta.maintainers = with lib.maintainers; [ eskytthe ];

  nodes = {
    machine =
      { ... }:
      {
        virtualisation.containerd.enable = true;
        environment.systemPackages = [
          pkgs.containerd
          pkgs.gnugrep
          pkgs.coreutils
        ];
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("containerd.service")
    machine.wait_until_succeeds("${pkgs.containerd}/bin/ctr version")

    machine.succeed("${pkgs.containerd}/bin/ctr images import --no-unpack ${passwdSymlinkImage}")
    machine.succeed("${pkgs.containerd}/bin/ctr images ls")

    ref = machine.succeed("${pkgs.containerd}/bin/ctr images ls -q | ${pkgs.gnugrep}/bin/grep -E '(^|/)nixos-symlink-passwd-test(:|@)' | head -n 1").strip()
    print("Imported image ref: " + ref)
    assert ref != ""

    # Runtime test of fix(oci): handle absolute symlinks in rootfs user lookup for /etc/passwd
    # https://github.com/containerd/containerd/pull/12732
    # TODO: Still issue for /etc/group:
    # https://github.com/containerd/containerd/issues/12683#issuecomment-3773170623
    out = machine.succeed("${pkgs.containerd}/bin/ctr run --rm --net-host --snapshotter native " + ref + " container1")
    print("ctr run output:\\n" + out)
    # User id and return string from Cmd in image
    assert "1000" in out
    assert "OK" in out
  '';
}
