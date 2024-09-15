{
  stdenv,
  lib,
  cmake,
  glibc,
  gfortran,
  makeWrapper,
  fetchFromGitHub,
  fetchpatch,
  dos2unix,
  dataRepo ? fetchFromGitHub {
    owner = "DSSAT";
    repo = "dssat-csm-data";
    rev = "v4.8.2.8";
    hash = "sha256-hbSBKEvdSd1lfbemfp4Lk4/JcGMXGVjm1x7P7lmmuA0=";
  },
}:
let
  # Temporary patch to fix 80 chars limit on paths
  # https://github.com/DSSAT/dssat-csm-os/pull/417/
  charLimitPatch = fetchpatch {
    url = "https://github.com/DSSAT/dssat-csm-os/pull/417/commits/9215012a297c074f392b5e7eb90b8c20495f13f7.patch";
    hash = "sha256-WwJR5lnWtR3aYWZmk8pBC0/qaRqY0UrWHIaYp2ajImE=";
  };
in
stdenv.mkDerivation (final: {
  pname = "dssat";
  version = "4.8.2.12";

  src = fetchFromGitHub {
    owner = "DSSAT";
    repo = "dssat-csm-os";
    rev = "refs/tags/v${final.version}";
    hash = "sha256-8OaTM7IXFZjlelx5O4O+bVNQj4dIhGzIk2iCfpqI8uA=";
  };

  # maintainers are on windows and have CRLF endings in their files
  # And github returns a patch file in unix format only.
  patchPhase = ''
    runHook prePatch
    cp ${charLimitPatch} ./limit-path.patch
    unix2dos ./limit-path.patch
    patch --binary -p1 < ./limit-path.patch
    runHook postPatch
  '';

  nativeBuildInputs = [
    cmake
    dos2unix
    gfortran
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isLinux [ glibc.static ];

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/dssat/" ];

  postInstall = ''
    mkdir -p $out/share/dssat/Data
    cp -r $src/Data/* $out/share/dssat/Data/
    cp -r ${dataRepo}/* $out/share/dssat/Data/
    makeWrapper $out/share/dssat/dscsm048 $out/bin/dscsm048
  '';

  meta = {
    homepage = "https://github.com/DSSAT/dssat-csm-os";
    description = "Cropping System Model";
    mainProgram = "dscsm048";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
    broken = stdenv.isAarch64 && stdenv.isLinux;
  };
})
