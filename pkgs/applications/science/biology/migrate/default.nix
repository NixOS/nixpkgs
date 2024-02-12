{ stdenv, lib, gccStdenv, fetchurl, zlib, mpi }:

gccStdenv.mkDerivation rec {
  version = "3.7.2";
  pname = "migrate";

  src = fetchurl {
    url = "https://peterbeerli.com/migrate-html5/download_version3/${pname}-${version}.src.tar.gz";
    sha256 = "1p2364ffjc56i82snzvjpy6pkf6wvqwvlvlqxliscx2c303fxs8v";
  };

  buildInputs = [ zlib mpi ];
  setSourceRoot = "sourceRoot=$(echo */src)";
  buildFlags = [ "thread" "mpis" ];
  preInstall = "mkdir -p $out/man/man1";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Estimates population size, migration, population splitting parameters using genetic/genomic data";
    homepage = "https://peterbeerli.com/migrate-html5/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
