{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  mpi,
  mpiSupport ? true,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gslib";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "Nek5000";
    repo = "gslib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cQYCuw1wszcbVv7WXMl8fKssab1ZytsYia6u13o5kts=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  # gslib.h includes mpi.h when built with MPI
  propagatedBuildInputs = lib.optional mpiSupport mpi;

  makeFlags = [
    "CC=${if mpiSupport then "${lib.getDev mpi}/bin/mpicc" else "${stdenv.cc.targetPrefix}cc"}"
    "MPI=${if mpiSupport then "1" else "0"}"
    "BLAS=0"
    "CFLAGS=-O2"
    "LDFLAGS=-lm"
    "INSTALL_ROOT=${placeholder "out"}"
  ]
  ++ (
    if stdenv.hostPlatform.isStatic then
      [
        "STATIC=1"
        "SHARED=0"
      ]
    else
      [
        "STATIC=0"
        "SHARED=1"
      ]
  );

  enableParallelBuilding = true;

  # The default target also installs; only build the library here.
  buildFlags = [ "lib" ];

  passthru = {
    inherit mpiSupport;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scalable parallel gather/scatter and point-location library";
    longDescription = ''
      gslib is a lightweight C library from Nek5000 providing scalable
      gather/scatter communication kernels (gs), the crystal router, and
      robust parallel point location and interpolation for high-order
      spectral element meshes (findpts).
    '';
    homepage = "https://github.com/Nek5000/gslib";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ grahamnorris ];
    platforms = lib.platforms.unix;
  };
})
