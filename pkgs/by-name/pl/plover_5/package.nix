{
  lib,
  plover,
  python3Packages,
}:

(python3Packages.toPythonApplication python3Packages.plover_5).overrideAttrs (
  finalAttrs: previousAttrs: {
    passthru = previousAttrs.passthru or { } // {
      withPlugins = plover.withPlugins.override {
        python3 = (
          python3Packages.python.override (previousArgs: {
            packageOverrides = lib.composeExtensions (previousArgs.packageOverrides or (_: _: { })) (
              final: previous: {
                plover = final.plover_5;
              }
            );
          })
        );
      };
      tests = {
        plover-with-lapwing = finalAttrs.passthru.withPlugins (ps: with ps; [ plover-lapwing-aio ]);
      }
      // previousAttrs.passthru.tests or { };
    };
  }
)
