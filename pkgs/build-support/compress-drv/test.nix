{
  gzip,
  runCommand,
  compressDrv,
  compressDrvWeb,
  testers,
}:
let
  example = runCommand "sample-drv" { } ''
    mkdir $out
    printf '42\n%.0s' {1..1000} > $out/1.txt
    printf '43\n%.0s' {1..1000} > $out/1.md
    touch $out/2.png
    echo 42 > $out/tiny.txt
    touch $out/'" '.txt # filenames must not be eval'ed or split by a shell
  '';
  compressTxtArgs = {
    formats = [ "txt" ];
    compressors.gz = "${gzip}/bin/gzip --force --keep --fast {}";
  };
  drv = compressDrv example compressTxtArgs;
  prunedDrv = compressDrv example {
    formats = [ "txt" ];
    removeIfSmaller = true;
    compressors = compressTxtArgs.compressors // {
      same = "sh -c 'cp -L \"$0\" \"$0.same\"' {}";
    };
  };
  webDrv = compressDrvWeb example { };
  webPrunedDrv = compressDrvWeb example { removeIfSmaller = true; };
  noSidecar = testers.testBuildFailure (
    compressDrv example {
      formats = [ "txt" ];
      removeIfSmaller = true;
      compressors.none = "true {}";
    }
  );
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
  test "$(stat -c%s ${drv}/tiny.txt.gz)" -ge "$(stat -L -c%s ${drv}/tiny.txt)"
  cmp ${drv}/tiny.txt <(${gzip}/bin/zcat ${drv}/tiny.txt.gz)

  cmp ${drv}/1.txt <(${gzip}/bin/zcat ${prunedDrv}/1.txt.gz)
  test -h ${prunedDrv}/tiny.txt
  test ! -e ${prunedDrv}/tiny.txt.gz
  test ! -e ${prunedDrv}/1.txt.same
  test -f ${webDrv}/tiny.txt.zst
  test -f ${webPrunedDrv}/1.txt.zst
  test ! -e ${webPrunedDrv}/tiny.txt.zst
  grep -q 'tiny.txt.none' ${noSidecar}/testBuildFailure.log

  # compressDrv always points to the final file, no matter how many times
  # it's been wrapped
  cmp <(readlink -e ${drv}/1.txt) <(readlink -e ${wrapped}/1.txt)

  test -f ${wrapped}/1.txt.gz
  test -f ${wrapped}/1.md.gz
  test ! -f ${drv}/1.md.gz

  mkdir $out
''
