import ./make-test-python.nix ({ pkgs, ... }:

let
  # Download Big Buck Bunny example, licensed under CC Attribution 3.0.
  testMkv = pkgs.fetchurl {
    url = "https://github.com/Matroska-Org/matroska-test-files/blob/cf0792be144ac470c4b8052cfe19bb691993e3a2/test_files/test1.mkv?raw=true";
    sha256 = "1hfxbbgxwfkzv85pvpvx55a72qsd0hxjbm9hkl5r3590zw4s75h9";
    name = "test1.mkv";
  };

in
{
  name = "handbrake";

  meta = {
    maintainers = with pkgs.lib.maintainers; [ ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ handbrake ];
  };

  testScript = ''
    # Test MP4 and MKV transcoding. Since this is a short clip, transcoding typically
    # only takes a few seconds.
    start_all()

    machine.succeed("HandBrakeCLI -i ${testMkv} -o test.mp4 -e x264 -q 20 -B 160")
    machine.succeed("test -e test.mp4")
    machine.succeed("HandBrakeCLI -i ${testMkv} -o test.mkv -e x264 -q 20 -B 160")
    machine.succeed("test -e test.mkv")
  '';
})
