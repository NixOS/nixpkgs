{ pkgs
, lib
, haskellPackages
, haskell
, runCommand
, buildPackages
}:

let

  /* This derivation builds the arion tool.

     It is based on the arion-compose Haskell package, but adapted and extended to
       - have the correct name
       - have a smaller closure size
       - have functions to use Arion from inside Nix: arion.eval and arion.build
       - make it self-contained by including docker-compose
   */
  arion =
    (justStaticExecutables (
      overrideCabal
        cabalOverrides
        arion-compose
      )
    ).overrideAttrs (o: {
      # Patch away the arion-compose name. Unlike the Haskell library, the program
      # is called arion (arion was already taken on hackage).
      pname = "arion";
    });

  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  inherit (haskellPackages) arion-compose;

  cabalOverrides = o: {
    buildTools = (o.buildTools or []) ++ [buildPackages.makeWrapper];
    passthru = (o.passthru or {}) // {
      inherit eval build;
    };
    src = arion-compose.src;

    # PYTHONPATH
    #
    # We close off the python module search path!
    #
    # Accepting directories from the environment into the search path
    # tends to break things. Docker Compose does not have a plugin
    # system as far as I can tell, so I don't expect this to break a
    # feature, but rather to make the program more robustly self-
    # contained.

    postInstall = ''${o.postInstall or ""}
      mkdir -p $out/libexec
      mv $out/bin/arion $out/libexec
      makeWrapper $out/libexec/arion $out/bin/arion \
        --unset PYTHONPATH \
        --prefix PATH : ${lib.makeBinPath [ pkgs.docker-compose_1 ]} \
        ;
    '';
  };

  # Unpacked sources for evaluation by `eval`
  srcUnpacked = runCommand "arion-src" {}
    "mkdir $out; tar -C $out --strip-components=1 -xf ${arion-compose.src}";

  /* Function for evaluating a composition

     Re-uses this Nixpkgs evaluation instead of `arion-pkgs.nix`.

     Returns the module system's `config` and `options` variables.
   */
  eval = args@{...}:
    import (srcUnpacked + "/src/nix/eval-composition.nix")
      ({ inherit pkgs; } // args);

  /* Function to derivation of the docker compose yaml file
     NOTE: The output will change: https://github.com/hercules-ci/arion/issues/82

    This function is particularly useful on CI, although the references
    to image tarballs may not always be desirable.
   */
  build = args@{...}:
    let composition = eval args;
    in composition.config.out.dockerComposeYaml;

in arion
