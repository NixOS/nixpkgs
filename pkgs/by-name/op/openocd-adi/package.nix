{
  openocd,
  autoreconfHook,
  lib,
  fetchFromGitHub,
}:

openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-adi";
    version = "0.12.0-1.3.1-2";
    src = fetchFromGitHub {
      owner = "analogdevicesinc";
      repo = "openocd";
      tag = finalAttrs.version;
      hash = "sha256-MqpVZN6+kcu1bspwcCDOnydQ5tC+MtO4D35KmQFRm1o=";
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
