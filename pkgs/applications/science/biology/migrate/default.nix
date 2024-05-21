{
  stdenv,
  lib,
  fetchurl,
  zlib,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.0.6";
  pname = "migrate";

  src = fetchurl {
    url = "https://peterbeerli.com/migrate-html5/download_version4/${finalAttrs.pname}-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-twkoR9L6VPUye12OC0B5w0PxcxyKain6RkhCswLEdwg=";
  };

  sourceRoot = "migrate-${finalAttrs.version}/src";

  buildInputs = [
    zlib
    mpi
  ];

  buildFlags = [
    "thread"
    "mpis"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Estimates population size, migration, population splitting parameters using genetic/genomic data";
    homepage = "https://peterbeerli.com/migrate-html5/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
    mainProgram = "migrate-n";
  };
})
