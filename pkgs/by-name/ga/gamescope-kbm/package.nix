{
  lib,
  fetchFromGitHub,
  gamescope,
}:

gamescope.overrideAttrs (
  _finalAttrs: previousAttrs: {
    pname = "gamescope-kbm";
    version = "0-unstable-2026-03-11";

    __structuredAttrs = true;

    # This fork is pinned to a PartyDeck commit and does not follow
    # ValveSoftware/gamescope releases.
    # nixpkgs-update: no auto update
    src = fetchFromGitHub {
      owner = "partydeck";
      repo = "gamescope";
      rev = "074c4f6f6f07d473af995717cc647e43efef741c";
      fetchSubmodules = true;
      hash = "sha256-IHxM1j2HMf5hC2GjTq4fI3qs3ev/AFwP2CPcyF6203o=";
    };

    mesonFlags = previousAttrs.mesonFlags ++ [
      (lib.mesonOption "benchmark" "disabled")
      (lib.mesonOption "input_emulation" "disabled")
    ];

    # Reuse upstream gamescope fixups, but apply them to the renamed binary.
    postInstall = ''
      mv $out/bin/gamescope $out/bin/gamescope-kbm
    ''
    +
      builtins.replaceStrings [ "$out/bin/gamescope" ] [ "$out/bin/gamescope-kbm" ]
        previousAttrs.postInstall;

    # Do not inherit gamescope's update script for ValveSoftware/gamescope.
    passthru = { };

    meta = previousAttrs.meta // {
      description = "Gamescope fork with keyboard and mouse device filtering support";
      homepage = "https://github.com/partydeck/gamescope";
      mainProgram = "gamescope-kbm";
      maintainers = [ lib.maintainers.imalison ];
    };
  }
)
