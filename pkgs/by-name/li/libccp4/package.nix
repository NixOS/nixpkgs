{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  meson,
  ninja,
  hdf5,
  gsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libccp4";
  version = "8.0.0";

  src = fetchurl {
    url = "https://ftp.ccp4.ac.uk/opensource/libccp4-${finalAttrs.version}.tar.gz";
    hash = "sha256-y4E66GYSoIZjKd6rfO6W6sVz2BvlskA0HUD5rVMi/y0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    hdf5
    gsl
  ];

  configureFlags = [ "FFLAGS=-fallow-argument-mismatch" ];

  # libccp4 tries to read syminfo.lib by looking at an environment variable, which hinders reproducibility.
  # We hard-code this by providing a little patch and then passing the absolute path to syminfo.lib as a
  # preprocessor flag.
  env.NIX_CFLAGS_COMPILE = "-DNIX_PROVIDED_SYMOP_FILE=\"${placeholder "out"}/share/ccp4/syminfo.lib\"";

  patches = [
    ./libccp4-use-hardcoded-syminfo-lib.patch
  ];

  postPatch =
    let
      mesonPatch = fetchzip {
        url = "https://wrapdb.mesonbuild.com/v2/libccp4c_8.0.0-1/get_patch#somefile.zip";
        hash = "sha256-ohskfKh+972Pl56KtwAeWwHtAaAFNpCzz5vZBAI/vdU=";
      };
    in
    ''
      cp ${mesonPatch}/meson.build .

      substituteInPlace ccp4/library_utils.c \
        --replace-fail "  int putenv ();" "  int putenv (char *);"
    '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Software for Macromolecular X-Ray Crystallography";
    homepage = "https://www.ccp4.ac.uk/";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
})
