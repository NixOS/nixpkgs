# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ lib, fetchurl, unzip }:

{ name ? "source"
, url
  # Optionally move the contents of the unpacked tree up one level.
, stripRoot ? true
, extraPostFetch ? ""
, ... } @ args:

(fetchurl ({
  inherit name;

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    unpackDir="$TMPDIR/unpack"
    mkdir "$unpackDir"
    cd "$unpackDir"

    renamed="$TMPDIR/${baseNameOf url}"
    mv "$downloadedFile" "$renamed"
    unpackFile "$renamed"
    result=$unpackDir
  ''
  # Most src disted tarballs have a parent directory like foo-1.2.3/ to strip
  + lib.optionalString stripRoot ''
    if [ $(ls "$unpackDir" | wc -l) != 1 ]; then
      echo "error: zip file must contain a single file or directory."
      echo "hint: Pass stripRoot=false; to fetchzip to assume flat list of files."
      exit 1
    fi
    fn=$(cd "$unpackDir" && echo *)
    result="$unpackDir/$fn"
  '' + ''
    mkdir $out
    mv "$result" "$out"
  ''
  + extraPostFetch;

} // removeAttrs args [ "stripRoot" "extraPostFetch" ])).overrideAttrs (x: {
  # Hackety-hack: we actually need unzip hooks, too
  nativeBuildInputs = x.nativeBuildInputs ++ [ unzip ];
})
