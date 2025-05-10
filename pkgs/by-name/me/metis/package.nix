{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  gklib,
  llvmPackages,
  isILP64 ? false,
  precision ? "single",
}:
assert precision == "single" || precision == "double";
let
  configFlags = toString (
    lib.optional isILP64 "i64=1" ++ lib.optional (precision == "double") "r64=1"
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "metis";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "METIS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eddLR6DvZ+2LeR0DkknN6zzRvnW+hLN2qeI+ETUPcac=";
  };

  # link metis to gklib
  patches = [
    (fetchpatch2 {
      url = "https://github.com/KarypisLab/METIS/pull/77/commits/8170703201722b25dfae631fc6a6997e9f01a655.patch";
      hash = "sha256-FKvrepKp0Z3FuXhtpFn+ggveKkzOqCldkKjE4kYu3JY=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gklib ] ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  preConfigure = ''
    make ${configFlags} config
  '';

  cmakeFlags = [
    (lib.cmakeBool "OPENMP" true)
    (lib.cmakeBool "SHARED" (!stdenv.hostPlatform.isStatic))
  ];

  passthru = {
    inherit isILP64 precision;
  };

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "https://karypis.github.io/glaros/software/metis/overview.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
