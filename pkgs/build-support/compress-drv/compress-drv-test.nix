{
  gzip,
  callPackage,
  runCommand,
}: let
  compressDrv = (callPackage ./compress-drv.nix {}).compressDrv;

  example = runCommand "sample-drv" {} ''
    mkdir $out
    echo 1 > $out/1.txt
    touch $out/2.png
  '';
  drv = compressDrv example {
    formats = ["txt"];
    compressors = ["gz"];
    compressor-gz = "${gzip}/bin/gzip --force --keep --fast {}";
  };
in
  runCommand "test-compressDrv" {} ''
    set -ex
    find ${drv}
    test -h ${drv}/1.txt
    test -f ${drv}/1.txt.gz
    cmp ${drv}/1.txt <(${gzip}/bin/zcat ${drv}/1.txt.gz)

    test -h ${drv}/2.png
    test ! -a ${drv}/2.png.gz
    mkdir $out
  ''
