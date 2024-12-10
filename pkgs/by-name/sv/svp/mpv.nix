{
  lib,
  mpv-unwrapped,
  wrapMpv,
  ocl-icd,
  ...
}:
let
  libraries = [
    ocl-icd
  ];
in
wrapMpv
  (mpv-unwrapped.override {
    vapoursynthSupport = true;
  })
  {
    extraMakeWrapperArgs = [
      # Add paths to required libraries
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "/run/opengl-driver/lib:${lib.makeLibraryPath libraries}"
    ];
  }
