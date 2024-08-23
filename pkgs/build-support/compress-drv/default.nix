{ lib, runCommand }:
/**
  Compresses files of a given derivation, and returns a new derivation with
  compressed files

  # Inputs

  `formats` ([String])

  : List of file extensions to compress. Example: `["txt" "svg" "xml"]`.

  `extraFindOperands` (String)

  : Extra command line parameters to pass to the find command.
    This can be used to exclude certain files.
    For example: `-not -iregex ".*(\/apps\/.*\/l10n\/).*"`

  `compressors` ( { ${fileExtension} :: String })

  : Map a desired extension (e.g. `gz`) to a compress program.

    The compressor program that will be executed to get the `COMPRESSOR` extension.
    The program should have a single " {}", which will be the replaced with the
    target filename.

    Compressor must:

    - read symlinks (thus --force is needed to gzip, zstd, xz).
    - keep the original file in place (--keep).

  # Type

  ```
  compressDrv :: Derivation -> { formats :: [ String ]; compressors :: { ${fileExtension} :: String; } } -> Derivation
  ```

  # Examples
  :::{.example}
  ## `pkgs.compressDrv` usage example
  ```
  compressDrv pkgs.spdx-license-list-data.json {
    formats = ["json"];
    compressors = {
      gz = "${zopfli}/bin/zopfli --keep {}";
    };
  }
  =>
  «derivation /nix/store/...-spdx-license-list-data-3.24.0-compressed.drv»
  ```

  See also pkgs.compressDrvWeb, which is a wrapper on top of compressDrv, for broader usage
  examples.
  :::
*/
drv:
{
  formats,
  compressors,
  extraFindOperands ? "",
}:
let
  validProg =
    ext: prog:
    let
      matches = (builtins.length (builtins.split "\\{}" prog) - 1) / 2;
    in
    lib.assertMsg (
      matches == 1
    ) "compressor ${ext} needs to have exactly one '{}', found ${builtins.toString matches}";
  mkCmd =
    ext: prog:
    assert validProg ext prog;
    ''
      find -L $out -type f -regextype posix-extended -iregex '.*\.(${formatsPipe})' ${extraFindOperands} -print0 \
        | xargs -0 -P$NIX_BUILD_CORES -I{} ${prog}
    '';
  formatsPipe = lib.concatStringsSep "|" formats;
in
runCommand "${drv.name}-compressed"
  (
    (lib.optionalAttrs (drv ? pname) { inherit (drv) pname; })
    // (lib.optionalAttrs (drv ? version) { inherit (drv) version; })
  )
  ''
    mkdir $out

    # cannot use lndir here, because it stop recursing at symlinks that point to directories
    (cd ${drv}; find -L -type d -exec mkdir -p $out/{} ';')
    (cd ${drv}; find -L -type f -exec ln -s ${drv}/{} $out/{} ';')

    ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList mkCmd compressors)}
  ''
