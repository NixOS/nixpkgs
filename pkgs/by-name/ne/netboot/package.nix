{
  lib,
  stdenv,
  fetchurl,
  bison,
  lzo,
  db4,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netboot";
  version = "0.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/netboot/netboot-${finalAttrs.version}.tar.gz";
    hash = "sha256-4HFIsMOW+owsVCOZt5pq2q+oRoS5fAmR/R2sx/dKgCc=";
  };

  buildInputs = [
    bison
    lzo
    db4
  ];

  hardeningDisable = [ "format" ];

  # mgllex.l:398:53: error: passing argument 1 of 'copy_string' from incompatible pointer type []
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  # Disable parallel build, errors:
  #  link: `parseopt.lo' is not a valid libtool object
  enableParallelBuilding = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/nbdbtool";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Mini PXE server";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.gpl2Only;
  };
})
