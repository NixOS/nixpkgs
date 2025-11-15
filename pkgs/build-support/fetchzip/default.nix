# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{
  lib,
  repoRevToNameMaybe,
  fetchurl,
  withUnzip ? true,
  unzip,
  glibcLocalesUtf8,
}:

let
  extendDrvArgs =
    finalAttrs:
    {
      url ? "",
      urls ? [ ],
      name ? repoRevToNameMaybe (if url != "" then url else builtins.head urls) null "unpacked",
      nativeBuildInputs ? [ ],
      postFetch ? "",
      extraPostFetch ? "",

      # Optionally move the contents of the unpacked tree up one level.
      stripRoot ? true,
      # Allows to set the extension for the intermediate downloaded
      # file. This can be used as a hint for the unpackCmdHooks to select
      # an appropriate unpacking tool.
      extension ? null,

      # Additional stdenvNoCC.mkDerivation arguments.
      # It is typically for derived fetchers to pass down additional arguments,
      # and the specified arguments have lower precedence than other mkDerivation arguments.
      derivationArgs ? { },

      # the rest are given to fetchurl as is
      ...
    }@args:

    let
      tmpFilename =
        if finalAttrs.extension != null then
          "download.${finalAttrs.extension}"
        else
          baseNameOf (if url != "" then url else builtins.head urls);
    in

    {
      inherit name;
      recursiveHash = true;

      downloadToTemp = true;

      # Have to pull in glibcLocalesUtf8 for unzip in setup-hook.sh to handle
      # UTF-8 aware locale:
      #   https://github.com/NixOS/nixpkgs/issues/176225#issuecomment-1146617263
      nativeBuildInputs =
        lib.optionals withUnzip [
          unzip
          glibcLocalesUtf8
        ]
        ++ nativeBuildInputs;

      postFetch = ''
        unpackDir="$TMPDIR/unpack"
        mkdir "$unpackDir"
        cd "$unpackDir"

        renamed="$TMPDIR/${tmpFilename}"
        mv "$downloadedFile" "$renamed"
        unpackFile "$renamed"
        chmod -R +w "$unpackDir"
      ''
      + (
        if finalAttrs.stripRoot then
          ''
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
          ''
        else
          ''
            mv "$unpackDir" "$out"
          ''
      )
      + ''
        ${postFetch}
        ${lib.warnIf (extraPostFetch != "")
          "use 'postFetch' instead of 'extraPostFetch' with 'fetchzip' and 'fetchFromGitHub' or 'fetchFromGitLab'."
          extraPostFetch
        }
        chmod 755 "$out"
      '';
      # ^ Remove non-owner write permissions
      # Fixes https://github.com/NixOS/nixpkgs/issues/38649

      derivationArgs = derivationArgs // {
        inherit
          extension
          stripRoot
          ;
      };
    };
in
lib.extendMkDerivation {
  constructDrv = fetchurl;

  excludeDrvArgNames = [
    "extraPostFetch"

    # Pass via derivationArgs
    "extension"
    "stripRoot"
  ];

  inherit extendDrvArgs;
}
// {
  expectDrvArgs = lib.zipAttrsWith (_: lib.any lib.id) [
    (lib.mapAttrs (n: _: true)
      (extendDrvArgs { } (lib.functionArgs extendDrvArgs // { derivationArgs = { }; })).derivationArgs
    )
    fetchurl.expectDrvArgs
  ];
}
