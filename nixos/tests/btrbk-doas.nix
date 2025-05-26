import ./make-test-python.nix (
  { pkgs, ... }:

  let
    privateKey = ''
      -----BEGIN OPENSSH PRIVATE KEY-----
      b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
      QyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrwAAAJB+cF5HfnBe
      RwAAAAtzc2gtZWQyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrw
      AAAEBN75NsJZSpt63faCuaD75Unko0JjlSDxMhYHAPJk2/xXHxQHThDpD9/AMWNqQer3Tg
      9gXMb2lTZMn0pelo8xyvAAAADXJzY2h1ZXR6QGt1cnQ=
      -----END OPENSSH PRIVATE KEY-----
    '';
    publicKey = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHxQHThDpD9/AMWNqQer3Tg9gXMb2lTZMn0pelo8xyv
    '';
  in
  {
    name = "btrbk-doas";
    meta = with pkgs.lib; {
      maintainers = with maintainers; [
        symphorien
        tu-maurice
      ];
    };

    nodes = {
      archive =
        { ... }:
        {
          security.sudo.enable = false;
          security.doas.enable = true;
          environment.systemPackages = with pkgs; [ btrfs-progs ];
          # note: this makes the privateKey world readable.
          # don't do it with real ssh keys.
          environment.etc."btrbk_key".text = privateKey;
          services.btrbk = {
            extraPackages = [ pkgs.lz4 ];
            instances = {
              remote = {
                onCalendar = "minutely";
                settings = {
                  ssh_identity = "/etc/btrbk_key";
                  ssh_user = "btrbk";
                  stream_compress = "lz4";
                  volume = {
                    "ssh://main/mnt" = {
                      target = "/mnt";
                      snapshot_dir = "btrbk/remote";
                      subvolume = "to_backup";
                    };
                  };
                };
              };
            };
          };
        };

      main =
        { ... }:
        {
          security.sudo.enable = false;
          security.doas.enable = true;
          environment.systemPackages = with pkgs; [ btrfs-progs ];
          services.openssh = {
            enable = true;
            passwordAuthentication = false;
            kbdInteractiveAuthentication = false;
          };
          services.btrbk = {
            extraPackages = [ pkgs.lz4 ];
            sshAccess = [
              {
                key = publicKey;
                roles = [
                  "source"
                  "send"
                  "info"
                  "delete"
                ];
              }
            ];
            instances = {
              local = {
                onCalendar = "minutely";
                settings = {
                  volume = {
                    "/mnt" = {
                      snapshot_dir = "btrbk/local";
                      subvolume = "to_backup";
                    };
                  };
                };
              };
            };
          };
        };
    };

    testScript = ''
      start_all()

      # create btrfs partition at /mnt
      for machine in (archive, main):
        machine.succeed("dd if=/dev/zero of=/data_fs bs=120M count=1")
        machine.succeed("mkfs.btrfs /data_fs")
        machine.succeed("mkdir /mnt")
        machine.succeed("mount /data_fs /mnt")

      # what to backup and where
      main.succeed("btrfs subvolume create /mnt/to_backup")
      main.succeed("mkdir -p /mnt/btrbk/{local,remote}")

      # check that local snapshots work
      with subtest("local"):
          main.succeed("echo foo > /mnt/to_backup/bar")
          main.wait_until_succeeds("cat /mnt/btrbk/local/*/bar | grep foo")
          main.succeed("echo bar > /mnt/to_backup/bar")
          main.succeed("cat /mnt/btrbk/local/*/bar | grep foo")

      # check that btrfs send/receive works and ssh access works
      with subtest("remote"):
          archive.wait_until_succeeds("cat /mnt/*/bar | grep bar")
          main.succeed("echo baz > /mnt/to_backup/bar")
          archive.succeed("cat /mnt/*/bar | grep bar")
    '';
  }
)
