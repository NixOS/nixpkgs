{
  gzip,
  runCommand,
  compressDrv,
  compressDrvWeb,
}:
let
  example = runCommand "sample-drv" { } ''
    mkdir $out
    # highly redundant, gzip shrinks it well, must be kept
    printf '42\n%.0s' {1..1000} > $out/1.txt
    printf '43\n%.0s' {1..1000} > $out/1.md
    touch $out/2.png
    # too small to shrink under gzip's overhead, should be dropped
    echo 42 > $out/tiny.txt
  '';
  compressTxtArgs = {
    formats = [ "txt" ];
    compressors.gz = "${gzip}/bin/gzip --force --keep --fast {}";
  };
  drv = compressDrv example compressTxtArgs;
  keepLargerDrv = compressDrvWeb example (compressTxtArgs // { keepLarger = true; });
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
  test ! -e ${drv}/2.png.gz

  test -h ${drv}/tiny.txt
  test ! -e ${drv}/tiny.txt.gz

  test -h ${keepLargerDrv}/tiny.txt
  test -f ${keepLargerDrv}/tiny.txt.gz
  test "$(stat -c%s ${keepLargerDrv}/tiny.txt.gz)" -ge "$(stat -L -c%s ${keepLargerDrv}/tiny.txt)"
  cmp ${keepLargerDrv}/tiny.txt <(${gzip}/bin/zcat ${keepLargerDrv}/tiny.txt.gz)

  # compressDrv always points to the final file, no matter how many times
  # it's been wrapped
  cmp <(readlink -e ${drv}/1.txt) <(readlink -e ${wrapped}/1.txt)

  test -f ${wrapped}/1.txt.gz
  test -f ${wrapped}/1.md.gz
  test ! -f ${drv}/1.md.gz

  mkdir $out
''
