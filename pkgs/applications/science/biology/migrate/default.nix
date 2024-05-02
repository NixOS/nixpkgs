{
  stdenv,
  lib,
  gccStdenv,
  fetchurl,
  zlib,
  mpi,
}:

gccStdenv.mkDerivation rec {
  version = "5.0.6";
  pname = "migrate";

  src = fetchurl {
    url = "https://peterbeerli.com/migrate-html5/download_version4/${pname}-${version}.src.tar.gz";
    hash = "sha256-twkoR9L6VPUye12OC0B5w0PxcxyKain6RkhCswLEdwg=";
  };

  buildInputs = [
    zlib
    mpi
  ];
  setSourceRoot = "sourceRoot=$(echo */src)";
  buildFlags = [
    "thread"
    "mpis"
  ];
  preInstall = "mkdir -p $out/man/man1";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Estimates population size, migration, population splitting parameters using genetic/genomic data";
    homepage = "https://peterbeerli.com/migrate-html5/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
    mainProgram = "migrate-n";
  };
}
