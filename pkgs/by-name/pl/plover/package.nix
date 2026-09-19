{
  lib,
  config,
  # For wrapper
  callPackage,
  python3Packages,
  # For aliases
  plover_4,
}:

(python3Packages.toPythonApplication python3Packages.plover).overrideAttrs (
  finalAttrs: previousAttrs: {
    passthru = previousAttrs.passthru or { } // {
      /**
        Shorthand of
        ```nix
        python3.plover.wrapPloverExes python3.withPlugins (ps: [ ps.plover ] ++ selectPackages ps)
        ```
        ::: {.note}
        The result package is unrelated to the main package,
        and is not affected by overriding applying to the main package.
        Its `<pkg>.override` interface consists of only the `python3` argument,
        whose `packageOverrides` can be overridden.
        :::
      */
      withPlugins = callPackage ./with-plugins.nix { };
      tests = {
        plover-with-lapwing = finalAttrs.passthru.withPlugins (
          ps: with ps; [
            plover-lapwing-aio
          ]
        );
      }
      // previousAttrs.passthru.tests or { };
    };
  }
)
# Aliases to now-dropped plover.stable and plover.dev
# Added 2026-04-22
# TODO(@ShamrockLee): remove after Nixpkgs 25.11 EOL
// lib.optionalAttrs (config.allowAliases && !(lib.oldestSupportedReleaseIsAtLeast 2605)) {
  dev =
    lib.throwIf (lib.oldestSupportedReleaseIsAtLeast 2511)
      "plover.dev was renamed. Use plover, plover_5, or plover_4 instead."
      plover_4; # Added 2026-05-07
  stable = throw "plover.stable was renamed. Use plover instead."; # Added 2022-06-05; updated 2026-04-26
}
