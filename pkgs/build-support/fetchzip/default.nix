# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ fetchurl, unzip }:

{ # Optionally move the contents of the unpacked tree up one level.
  stripRoot ? true
, url
, extraPostFetch ? ""
, name ? "source"
, ... } @ args:

(fetchurl ({
  inherit name;

  recursiveHash = true;

  downloadToTemp = true;

  postFetch =
    ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${baseNameOf url}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
    ''
    + (if stripRoot then ''
      if [ $(ls "$unpackDir" | wc -l) != 1 ]; then
        echo "error: zip file must contain a single file or directory."
        echo "hint: Pass stripRoot=false; to fetchzip to assume flat list of files."
        exit 1
      fi
      fn=$(cd "$unpackDir" && echo *)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"
    '' else ''
      mv "$unpackDir" "$out"
    '')
    + extraPostFetch
    # Remove write permissions for files unpacked with write bits set
    # Fixes https://github.com/NixOS/nixpkgs/issues/38649
    #
    # However, we should (for the moment) retain write permission on the directory
    # itself, to avoid tickling https://github.com/NixOS/nix/issues/4295 in
    # single-user Nix installations. This is because in sandbox mode we'll try to
    # move the path, and if we don't have write permissions on the directory,
    # then we can't update the ".." entry.
    + ''
      chmod -R a-w "$out"
      chmod u+w "$out"
    '';
} // removeAttrs args [ "stripRoot" "extraPostFetch" ])).overrideAttrs (x: {
  # Hackety-hack: we actually need unzip hooks, too
  nativeBuildInputs = x.nativeBuildInputs ++ [ unzip ];
})
