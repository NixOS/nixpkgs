# Data flow for testing CRX2RNX and RNX2CRX (file type after each step in paranthesis):
# Example file --(.crx.gz)--> unzip --(.crx)--> CRX2RNX --(.rnx)--> RNX2CRX --(.crx)--> compare two crx files

# Data flow for testing CRZ2RNX and RNX2CRZ (file type after each step in paranthesis):
# Example files --(.crx.gz)--> CRZ2RNX --(.rnx)--> RNX2CRZ --(.crx.gz)--> unzip --(.crx)--v
#                         \--> unzip --(.crx)-------------------------------------------> compare crx files
# The last unzip step is needed because the .crx files themselves contain
# one line with the version number of the program and the current date,
# so they are not reproducible. This line needs to be removed to properly
# compare the files. To do this, we need to first unzip the files. The
# compression itself might also not be reproducible.

# Also compare the RINEX file (.rnx) from the CRX2RNX program to the one output by CRZ2RNX.

# Before running each of the four commands, we unset the PATH variable to make
# sure that the program does not depend on any external programs from the environment.

{
  lib,
  linkFarm,
  writeShellApplication,
  fetchurl,
  runCommand,
  rnxcmp,
}:
let
  # Download two small example files (<1M each)
  file-1-name = "ZARA00ESP_S_20260020100_15M_01S_MO";
  files = linkFarm "files" [
    rec {
      name = "${file-1-name}.crx.gz";
      path = fetchurl {
        url = "https://igs.bkg.bund.de/root_ftp/EUREF/highrate/2026/002/b/${name}";
        hash = "sha256-HUpzgFfwCf0N/OyJjJEStrOPPecmC4cr66DPbMjNyzc=";
      };
    }
    rec {
      name = "ZARA00ESP_S_20260020115_15M_01S_MO.crx.gz";
      path = fetchurl {
        url = "https://igs.bkg.bund.de/root_ftp/EUREF/highrate/2026/002/b/${name}";
        hash = "sha256-cnoYjcUwJMSvNB7f1HNCBi1hBKsuduOxrRw9S2Evopw=";
      };
    }
  ];

  assert-dir-not-empty-app = writeShellApplication {
    name = "assert-dir-not-empty";
    text = ''
      files="$(shopt -s nullglob dotglob; echo "$1/"*)"
      if ! (( ''${#files} ))
      then
        echo "ERROR: Previous command did not produce any files!"
        exit 1
      fi
    '';
  };
  assert-dir-not-empty = lib.getExe assert-dir-not-empty-app;

  # unzip GZIP archives
  unzip =
    files:
    runCommand "unzipped" { } ''
      mkdir "$out"
      cd '${files}'
      for filename in *; do
        gzip --verbose --decompress --keep --to-stdout "$filename" > "$out/$(basename "$filename" .gz)"
      done
      '${assert-dir-not-empty}' "$out"
    '';
  files-unzipped = unzip files;

  # Convert the file from CompactRINEX format to RINEX
  file-rnx = runCommand "file-rnx" { } ''
    mkdir "$out"
    unset PATH
    '${lib.getExe' rnxcmp "CRX2RNX"}' '${files-unzipped}/${file-1-name}.crx' - > "$out/${file-1-name}.rnx"
    '${assert-dir-not-empty}' "$out"
  '';

  # "Recompress" the file again
  file-recompressed = runCommand "file-recompressed" { } ''
    mkdir "$out"
    unset PATH
    '${lib.getExe' rnxcmp "RNX2CRX"}' '${file-rnx}/${file-1-name}.rnx' - > "$out/${file-1-name}.crx"
    '${assert-dir-not-empty}' "$out"
  '';

  file-comparison = compare files-unzipped file-recompressed;

  # Convert the files from CompactRINEX format to RINEX
  files-rnx = runCommand "files-rnx" { } ''
    mkdir "$out"
    cd "$out"
    unset PATH
    '${lib.getExe' rnxcmp "CRZ2RNX"}' -v -c '${files}/'*
    '${assert-dir-not-empty}' "$out"
  '';

  # "Recompress" the file again
  files-recompressed = runCommand "files-recompressed" { } ''
    mkdir "$out"
    cd "$out"
    unset PATH
    '${lib.getExe' rnxcmp "RNX2CRZ"}' -v -c '${files-rnx}/'*
    '${assert-dir-not-empty}' "$out"
  '';

  files-recompressed-unzipped = unzip files-recompressed;

  compare =
    files-before: files-after:
    runCommand "comparison" { } ''
      for filename in '${files-after}/'*; do
        filename="$(basename "$filename")"
        echo "Comparing old and new versions of $filename"

        # Delete software version and timestamp (second line)
        sed -e '2d' < "${files-before}/$filename" > before.crx
        sed -e '2d' < "${files-after}/$filename" > after.crx

        diff before.crx after.crx
      done
      touch "$out"
    '';
  files-comparison = compare files-unzipped files-recompressed-unzipped;

  comparison-rnx = runCommand "comparison-rnx" { } ''
    for filename in '${file-rnx}/'*; do
      filename="$(basename "$filename")"
      echo "Comparing old and new versions of $filename"

      diff "${files-rnx}/$filename" "${file-rnx}/$filename"
    done
    touch "$out"
  '';

in
{
  crx = file-comparison;
  crz = files-comparison;
  rnx = comparison-rnx;
}
