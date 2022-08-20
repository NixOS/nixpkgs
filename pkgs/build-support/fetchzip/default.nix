# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ lib, fetchurl, unzip, glibcLocalesUtf8 }:

{ # Optionally move the contents of the unpacked tree up one level.
  stripRoot ? true
, url ? ""
, urls ? []
, extraPostFetch ? ""
, postFetch ? ""
, name ? "source"
, nativeBuildInputs ? [ ]
, # Allows to set the extension for the intermediate downloaded
  # file. This can be used as a hint for the unpackCmdHooks to select
  # an appropriate unpacking tool.
  extension ? null
, ... } @ args:


lib.warnIf (extraPostFetch != "") "use 'postFetch' instead of 'extraPostFetch' with 'fetchzip' and 'fetchFromGitHub'."
(fetchurl (let
  tmpFilename =
    if extension != null
    then "download.${extension}"
    else baseNameOf (if url != "" then url else builtins.head urls);
in {
  inherit name;

  recursiveHash = true;

  downloadToTemp = true;

  # Have to pull in glibcLocalesUtf8 for unzip in setup-hook.sh to handle
  # UTF-8 aware locale:
  #   https://github.com/NixOS/nixpkgs/issues/176225#issuecomment-1146617263
  nativeBuildInputs = [ unzip glibcLocalesUtf8 ] ++ nativeBuildInputs;

  postFetch =
    ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${tmpFilename}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
      chmod -R +w "$unpackDir"
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
    + ''
      ${postFetch}
    '' + ''
      ${extraPostFetch}
    ''

    # Remove non-owner write permissions
    # Fixes https://github.com/NixOS/nixpkgs/issues/38649
    + ''
      chmod 755 "$out"
    '';
} // removeAttrs args [ "stripRoot" "extraPostFetch" "postFetch" "extension" "nativeBuildInputs" ]))
