{
  lib,
  pkgs,
  runTest,
}:
{

  # Assertion Tests
  assertions =
    let
      failures = import ./assertions.nix { inherit lib pkgs; };
      checked = lib.debug.throwTestFailures { inherit failures; };
    in
    builtins.seq checked (pkgs.runCommand "speechd-assertions-test" { } "touch $out");

  # Modules tests
  # keep-sorted start block=yes case=no
  espeakNg = runTest (
    import ./module-test.nix {
      inherit lib;
      defaultModule = "espeakNg";
      moduleConfig.debug = true;
    }
  );
  # FIXME uncomment when MBROLA voices are fixed in eSpeak
  # https://github.com/NixOS/nixpkgs/pull/541467
  # espeakNgMbrola = runTest (
  #   import ./module-test.nix {
  #     inherit lib;
  #     defaultModule = "espeakNg";
  #     moduleConfig = {
  #       debug = true;
  #       mbrola = true;
  #       mbrolaVoices = [
  #         "us1"
  #         "en1"
  #       ];
  #     };
  #   }
  # );
  flite = runTest (
    import ./module-test.nix {
      inherit lib;
      defaultModule = "flite";
      moduleConfig.debug = true;
    }
  );
  pico = runTest (
    import ./module-test.nix {
      inherit lib;
      defaultModule = "pico";
      moduleConfig.debug = true;
    }
  );
  # keep-sorted end
}
