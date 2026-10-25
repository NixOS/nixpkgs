{
  openocd,
  autoreconfHook,
  lib,
  fetchFromGitHub,
}:

openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-rp2040";
    version = "2.2.0";
    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "openocd";
      tag = "sdk-${finalAttrs.version}";
      hash = "sha256-ZfbZVFVncHa1MvNJb4jbnU66vnlwVLBaOXPdgLqAneM=";
      # openocd disables the vendored libraries that use submodules and replaces them with nix versions.
      # this works out as one of the submodule sources seems to be flakey.
      fetchSubmodules = false;
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      autoreconfHook
    ];
    meta = openocd.meta // {
      description = "Raspberry Pi's downstream fork of OpenOCD for use with Pico-series devices";
      homepage = "https://github.com/raspberrypi/openocd";
      maintainers = with lib.maintainers; [
        aiyion
        lu15w1r7h
      ];
    };
  }
)
