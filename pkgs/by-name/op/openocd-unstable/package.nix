{
  openocd,
  autoreconfHook,
  lib,
  fetchFromGitHub,
}:

openocd.overrideAttrs (
  finalAttrs: old: {
    pname = "openocd-unstable";
    version = "0.12.0-unstable-2026-06-11";
    src = fetchFromGitHub {
      owner = "openocd-org";
      repo = "openocd";
      rev = "1bf1ac444a96d9151ae53a1ccf5adf16f8e25e75";
      hash = "sha256-AuGuy0h8pYVcX8GpW4R/pBHmHsRZEGzqU3KLCmkSAs8=";
      fetchSubmodules = false;
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      autoreconfHook
    ];
    meta = openocd.meta // {
      description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing (git snapshot)";
      homepage = "https://github.com/openocd-org/openocd";
      maintainers = with lib.maintainers; [
        mkannwischer
      ];
    };
  }
)
