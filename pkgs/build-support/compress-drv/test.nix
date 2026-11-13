{
  gzip,
  runCommand,
  compressDrv,
}:
let
  example = runCommand "sample-drv" { } ''
    mkdir $out
    echo 42 > $out/1.txt
    echo 43 > $out/1.md
    touch $out/2.png
  '';
  drv = compressDrv example {
    formats = [ "txt" ];
    compressors.gz = "${gzip}/bin/gzip --force --keep --fast {}";
  };
  wrapped = compressDrv drv {
    formats = [ "md" ];
    compressors.gz = "${gzip}/bin/gzip --force --keep --fast {}";
  };
in
runCommand "test-compressDrv" { } ''
  set -ex

  ls -l ${drv}
  test -h ${drv}/1.txt
  test -f ${drv}/1.txt.gz
  cmp ${drv}/1.txt <(${gzip}/bin/zcat ${drv}/1.txt.gz)

  test -h ${drv}/2.png
  test ! -a ${drv}/2.png.gz

  # compressDrv always points to the final file, no matter how many times
  # it's been wrapped
  cmp <(readlink -e ${drv}/1.txt) <(readlink -e ${wrapped}/1.txt)

  test -f ${wrapped}/1.txt.gz
  test -f ${wrapped}/1.md.gz
  test ! -f ${drv}/1.md.gz

  mkdir $out
''
