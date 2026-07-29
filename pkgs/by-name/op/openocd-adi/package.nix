{
  openocd,
  autoreconfHook,
  lib,
  fetchFromGitHub,
}:

openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-adi";
    version = "0.12.0-1.4.0";
    src = fetchFromGitHub {
      owner = "analogdevicesinc";
      repo = "openocd";
      tag = finalAttrs.version;
      hash = "sha256-R8z5c7FpjqBpugQuY0TV1MQTv7Y8DQWe52NZP0qdfzM=";
      # openocd disables the vendored libraries that use submodules and replaces them with nix versions.
      # this works out as one of the submodule sources seems to be flakey.
      fetchSubmodules = false;
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      autoreconfHook
    ];
    meta = openocd.meta // {
      description = "ADI fork of OpenOCD";
      homepage = "https://github.com/analogdevicesinc/openocd";
      maintainers = with lib.maintainers; [
        aiyion
      ];
    };
  }
)
