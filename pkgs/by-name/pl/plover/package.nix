{
  lib,
  config,
  python3Packages,
  # For aliases
  plover,
}:
python3Packages.toPythonApplication python3Packages.plover
# Aliases to now-dropped plover.stable and plover.dev
# Added 2026-04-22
# TODO(@ShamrockLee): remove after Nixpkgs 25.11 EOL
// lib.optionalAttrs (config.allowAliases && !(lib.oldestSupportedReleaseIsAtLeast 2605)) {
  dev =
    lib.throwIf (lib.oldestSupportedReleaseIsAtLeast 2511) "plover.dev was renamed. Use plover instead."
      plover; # Added 2026-04-26
  stable = throw "plover.stable was renamed. Use plover instead."; # Added 2022-06-05; updated 2026-04-26
}
