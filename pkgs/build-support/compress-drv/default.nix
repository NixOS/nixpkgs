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
    For example:
      - exclude l10n directories under apps: `-not -iregex ".*(\/apps\/.*\/l10n\/).*"`
      - skip files of 256 bytes or less: `-size +256c`

  `removeIfSmaller` (Boolean; optional)

  : Remove compressed sidecars that are not smaller than their source files.
    Defaults to `false`.

  `compressors` ( { ${fileExtension} :: String })

  : Map a desired extension (e.g. `gz`) to a compress program.

    The compressor program that will be executed to get the `COMPRESSOR` extension.
    The extension must be the one the program appends to its output file.
    The program should have a single `{}`, which will be replaced with the
    target filename. Do not quote `{}`.

    Compressor must:

    - read symlinks (thus --force is needed to gzip, zstd, xz).
    - keep the original file in place (--keep).

  # Type

  ```
  compressDrv :: Derivation -> { formats :: [String]; compressors :: { ${fileExtension} :: String; }; extraFindOperands :: String; removeIfSmaller :: Bool; } -> Derivation
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
  removeIfSmaller ? false,
}:
let
  validProg =
    ext: prog:
    let
      matches = (builtins.length (builtins.split "\\{}" prog) - 1) / 2;
    in
    matches == 1 || throw "compressor ${ext} needs to have exactly one '{}', found ${toString matches}";
  mkCmd =
    ext: prog:
    assert validProg ext prog;
    ''
      find -L $out -type f -regextype posix-extended -iregex '.*\.(${formatsPipe})' ${extraFindOperands} -print0 \
        | xargs -0 -P$NIX_BUILD_CORES ${
          if !removeIfSmaller then
            "-I{} ${prog}"
          else
            "-n1 sh -c ${lib.escapeShellArg ''
              set -e
              ${lib.replaceStrings [ "{}" ] [ ''"$1"'' ] prog}
              [ "$(stat -L -c%s "$1.${ext}")" -lt "$(stat -L -c%s "$1")" ] || rm "$1.${ext}"
            ''} _"
        }
    '';
  formatsPipe = lib.concatStringsSep "|" formats;
in
runCommand "${drv.name}-compressed"
  (
    (lib.optionalAttrs (drv ? pname) { inherit (drv) pname; })
    // (lib.optionalAttrs (drv ? version) { inherit (drv) version; })
    // (lib.optionalAttrs (drv ? passthru) { inherit (drv) passthru; })
    // (lib.optionalAttrs (drv ? meta) { inherit (drv) meta; })
  )
  ''
    mkdir $out

    # cannot use lndir here, because it stop recursing at symlinks that point to directories
    (cd ${drv}; find -L -type d -exec mkdir -p $out/{} ';')
    (cd ${drv}; find -L -type f -exec ln -s ${drv}/{} $out/{} ';')

    ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList mkCmd compressors)}
  ''
