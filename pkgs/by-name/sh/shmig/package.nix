{
  stdenv,
  fetchFromGitHub,
  withMySQL ? true,
  withPSQL ? false,
  withSQLite ? false,
  mariadb,
  postgresql,
  sqlite,
  gawk,
  gnugrep,
  findutils,
  gnused,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "shmig";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mbucc";
    repo = "shmig";
    rev = "v${version}";
    sha256 = "15ry1d51d6dlzzzhck2x57wrq48vs4n9pp20bv2sz6nk92fva5l5";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    patchShebangs .

    substituteInPlace shmig \
      --replace "\`which mysql\`" "${lib.optionalString withMySQL "${mariadb.client}/bin/mysql"}" \
      --replace "\`which psql\`" "${lib.optionalString withPSQL "${postgresql}/bin/psql"}" \
      --replace "\`which sqlite3\`" "${lib.optionalString withSQLite "${sqlite}/bin/sqlite3"}" \
      --replace "awk" "${gawk}/bin/awk" \
      --replace "grep" "${gnugrep}/bin/grep" \
      --replace "find" "${findutils}/bin/find" \
      --replace "sed" "${gnused}/bin/sed"
  '';

  preBuild = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Minimalistic database migration tool with MySQL, PostgreSQL and SQLite support";
    mainProgram = "shmig";
    homepage = "https://github.com/mbucc/shmig";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
