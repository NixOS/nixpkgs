{ lib, stdenv, stdenvNoCC, lndir }:

let
  trivialBuilders = import ./trivial-builders.nix {
    inherit lib stdenv stdenvNoCC lndir;
    inherit (setupHooks) makeWrapper;
  };

  setupHooks = import ./setup-hooks {
    inherit (trivialBuilders) makeSetupHook writeScript;
  };

in trivialBuilders // setupHooks
