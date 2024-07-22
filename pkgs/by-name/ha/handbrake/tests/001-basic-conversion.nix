{
  fetchurl,
  handbrake,
  runCommand,
}:

let
  # Big Buck Bunny example, licensed under CC Attribution 3.0.
  testMkv = fetchurl {
    url = "https://github.com/Matroska-Org/matroska-test-files/blob/cf0792be144ac470c4b8052cfe19bb691993e3a2/test_files/test1.mkv?raw=true";
    hash = "sha256-CZajCf8glZELnTDVJTsETWNxVCl9330L2n863t9a3cE=";
  };
in
runCommand
  "${handbrake.pname}-${handbrake.version}-basic-conversion"
  {
    nativeBuildInputs = [
      handbrake
    ];
  }
  ''
    mkdir -p $out
    cd $out
    HandBrakeCLI -i ${testMkv} -o test.mp4 -e x264 -q 20 -B 160
    test -e test.mp4
    HandBrakeCLI -i ${testMkv} -o test.mkv -e x264 -q 20 -B 160
    test -e test.mkv
  ''
