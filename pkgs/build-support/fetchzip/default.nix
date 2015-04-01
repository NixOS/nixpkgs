# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ lib, fetchurl, unzip }:

{ # Optionally move the contents of the unpacked tree up one level.
  stripRoot ? true
, url
, ... } @ args:

lib.overrideDerivation (fetchurl ({
  name = args.name or (baseNameOf url);

  recursiveHash = true;

  downloadToTemp = true;

  postFetch =
    ''
      export PATH=${unzip}/bin:$PATH
      mkdir $out

      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${baseNameOf url}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"

      shopt -s dotglob
    ''
    + (if stripRoot then ''
      if [ $(ls "$unpackDir" | wc -l) != 1 ]; then
        echo "error: zip file must contain a single file or directory."
        exit 1
      fi
      fn=$(cd "$unpackDir" && echo *)
      if [ -f "$unpackDir/$fn" ]; then
        mv "$unpackDir/$fn" "$out"
      else
        mv "$unpackDir/$fn"/* "$out/"
      fi
    '' else ''
      mv "$unpackDir"/* "$out/"
    '');
} // removeAttrs args [ "stripRoot" ]))
# Hackety-hack: we actually need unzip hooks, too
(x: {nativeBuildInputs = x.nativeBuildInputs++ [unzip];})
