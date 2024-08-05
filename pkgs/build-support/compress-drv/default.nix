{
  lib,
  xorg,
  runCommand,
}:
/**
  #  compressDrv compresses files in a given derivation.

  ## Inputs:

  `formats` ([String])

  : List of file extensions to compress. Example: `["txt" "svg" "xml"]`.

  `compressors` (String -> String)

  : Map a desired extension (e.g. `gz`) to a compress program.

  The compressor program that will be executed to get the `COMPRESSOR` extension.
  The program should have a single " {}", which will be the replaced with the
  target filename.

  Compressor must:
  - read symlinks (thus --force is needed to gzip, zstd, xz).
  - keep the original file in place (--keep).

  Example:

  ```
  {
    xz = "${xz}/bin/xz --force --keep {}";
  }
  ```

  See compressDrvWeb, which is a wrapper on top of compressDrv, for broader use
  examples.
*/
drv:
{ formats, compressors, ... }:
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
      find -L $out -type f -regextype posix-extended -iregex '.*\.(${formatsPipe})' -print0 \
        | xargs -0 -P$NIX_BUILD_CORES -I{} ${prog}
    '';
  formatsPipe = builtins.concatStringsSep "|" formats;
in
runCommand "${drv.name}-compressed" { } ''
  mkdir $out
  (cd $out; ${xorg.lndir}/bin/lndir ${drv})

  ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList mkCmd compressors)}
''
