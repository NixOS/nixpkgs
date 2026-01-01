{
  lib,
<<<<<<< HEAD
  mpv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mpv-unwrapped,
  ocl-icd,
}:

<<<<<<< HEAD
mpv.override {
  mpv-unwrapped = mpv-unwrapped.override { vapoursynthSupport = true; };
=======
mpv-unwrapped.wrapper {
  mpv = mpv-unwrapped.override { vapoursynthSupport = true; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraMakeWrapperArgs = [
    # Add paths to required libraries
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}"
  ];
}
