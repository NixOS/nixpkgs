{
  cmake,
  fetchurl,
  lib,
  libbsd,
  ncurses,
  postgresql,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pg_top";
  version = "4.1.1";

  src = fetchurl {
    url = "https://pg_top.gitlab.io/source/pg_top-${version}.tar.xz";
    sha256 = "sha256-85LObBS9aAt7Ck5yiK0g2CAKxiYtnWp5XnTAUB5ui/k=";
  };

  buildInputs = [
    libbsd
    ncurses
    postgresql
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "'top' like tool for PostgreSQL";
    longDescription = ''
      pg_top allows you to:
       * View currently running SQL statement of a process.
       * View query plan of a currently running SELECT statement.
       * View locks held by a process.
       * View I/O statistics per process.
       * View replication statistics for downstream nodes.
    '';

    homepage = "https://pg_top.gitlab.io";
    changelog = "https://gitlab.com/pg_top/pg_top/-/blob/main/HISTORY.rst";
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "pg_top";
  };
}
