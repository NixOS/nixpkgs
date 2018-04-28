{ lib, fetchurl, unzip }:

{ crateName
, version
, sha256
, extraPostFetch ? ""
, ... } @ args:

lib.overrideDerivation (fetchurl ({

  name = "${crateName}-${version}.tar.gz";
  url = "https://crates.io/api/v1/crates/${crateName}/${version}/download";
  recursiveHash = true;

  downloadToTemp = true;

  postFetch =
    ''
      export PATH=${unzip}/bin:$PATH

      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${crateName}-${version}.tar.gz"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
      fn=$(cd "$unpackDir" && echo *)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"

      ${extraPostFetch}
    '';
} // removeAttrs args [ "crateName" "version" "extraPostFetch" ]))
# Hackety-hack: we actually need unzip hooks, too
(x: {nativeBuildInputs = x.nativeBuildInputs++ [unzip];})
