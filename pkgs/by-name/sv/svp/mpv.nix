{ lib
, mpv-unwrapped
, wrapMpv
, ocl-icd
, ...
}:
let
  libraries = [
    ocl-icd
  ];
in
wrapMpv
  ((mpv-unwrapped.override {
    vapoursynthSupport = true;
  }).overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ [
        # Credit to @xrun1
        # https://github.com/NixOS/nixpkgs/issues/295429
        # https://github.com/xrun1/mpv-svp-fix
        ./xrun1-restore-vf-del-option.patch
      ];
  }))
{
  extraMakeWrapperArgs = [
    # Add paths to required libraries
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib:${lib.makeLibraryPath libraries}"
  ];
}
