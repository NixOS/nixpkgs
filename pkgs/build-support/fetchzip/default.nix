# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ lib, fetchurl, unzip, glibcLocalesUtf8 }:

{ name ? "source"

# Optionally move the contents of the unpacked tree up one level.
#, stripRoot ? true

# This allows to set the extension for the intermediate downloaded
# file. This can be used as a hint for the unpackCmdHooks to select
# an appropriate unpacking tool.
#, extension ? null

# the rest are given to fetchurl as is
, ... } @ args:

assert (args ? extraPostFetch)
       -> (lib.warn "use 'postFetch' instead of 'extraPostFetch' with 'fetchzip' and 'fetchFromGitHub'." true);

fetchurl (removeAttrs args [
  "stripRoot" "extraPostFetch" "extension"
] // {
  name = if (args ? pname && args ? version) then "${args.pname}-${args.version}" else name;
  recursiveHash = true;

  downloadToTemp = true;

  # Have to pull in glibcLocalesUtf8 for unzip in setup-hook.sh to handle
  # UTF-8 aware locale:
  #   https://github.com/NixOS/nixpkgs/issues/176225#issuecomment-1146617263
  nativeBuildInputs = [ unzip glibcLocalesUtf8 ] ++ (args.nativeBuildInputs or []);

  postFetch =
    ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${if args ? extension
        then "download.${args.extension}"
        else baseNameOf (args.url or (builtins.head args.urls))}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
      chmod -R +w "$unpackDir"
    ''
    + (if args.stripRoot or true then ''
      if [ $(ls -A "$unpackDir" | wc -l) != 1 ]; then
        echo "error: zip file must contain a single file or directory."
        echo "hint: Pass stripRoot=false; to fetchzip to assume flat list of files."
        exit 1
      fi
      fn=$(cd "$unpackDir" && ls -A)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"
    '' else ''
      mv "$unpackDir" "$out"
    '')
    + ''
      ${args.postFetch or ""}
      ${args.extraPostFetch or ""}
    ''

    # Remove non-owner write permissions
    # Fixes https://github.com/NixOS/nixpkgs/issues/38649
    + ''
      chmod 755 "$out"
    '';
})
