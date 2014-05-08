# This function downloads and unpacks a zip file. This is primarily
# useful for dynamically generated zip files, such as GitHub's
# /archive URLs, where the unpacked content of the zip file doesn't
# change, but the zip file itself may (e.g. due to minor changes in
# the compression algorithm, or changes in timestamps).

{ lib, fetchurl, unzip }:

{ # Optionally move the contents of the unpacked tree up one level.
  stripRoot ? true
, ... } @ args:

fetchurl (args // {
  # Apply a suffix to the name. Otherwise, unpackPhase will get
  # confused by the .zip extension.
  nameSuffix = "-unpacked";

  recursiveHash = true;

  downloadToTemp = true;

  postFetch =
    ''
      export PATH=${unzip}/bin:$PATH
      mkdir $out
      cd $out
      renamed="$TMPDIR/''${name%-unpacked}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
    ''
    # FIXME: handle zip files that contain a single regular file.
    + lib.optionalString stripRoot ''
      shopt -s dotglob
      if [ "$(ls -d $out/* | wc -l)" != 1 ]; then
        echo "error: zip file must contain a single directory."
        exit 1
      fi
      fn=$(cd "$out" && echo *)
      mv $out/$fn/* "$out/"
      rmdir "$out/$fn"
    '';
})
