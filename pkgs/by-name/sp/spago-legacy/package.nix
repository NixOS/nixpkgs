{
  haskell,
  haskellPackages,
  lib,

  # The following are only needed for the passthru.tests:
  spago-legacy,
  cacert,
  git,
  nodejs,
  purescript,
  runCommand,
}:

lib.pipe haskellPackages.spago-legacy [
  haskell.lib.compose.justStaticExecutables

  (haskell.lib.compose.overrideCabal (oldAttrs: {
    changelog = "https://github.com/purescript/spago-legacy/releases/tag/${oldAttrs.version}";

    passthru = (oldAttrs.passthru or { }) // {
      updateScript = ./update.sh;

      # These tests can be run with the following command.  The tests access the
      # network, so they cannot be run in the nix sandbox.  sudo is needed in
      # order to change the sandbox option.
      #
      # $ sudo nix-build -A spago-legacy.passthru.tests --option sandbox relaxed
      #
      tests =
        runCommand "spago-legacy-tests"
          {
            __noChroot = true;
            nativeBuildInputs = [
              cacert
              git
              nodejs
              purescript
              spago-legacy
            ];
          }
          ''
            # spago expects HOME to be set because it creates a cache file under
            # home.
            HOME=$(pwd)

            spago --verbose init
            spago --verbose build
            spago --verbose test

            touch $out
          '';
    };
  }))
]
