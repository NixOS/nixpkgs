{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  sqlite,
}:

buildGoModule rec {
  pname = "mobsql";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mobsql";
    rev = "v${version}";
    hash = "sha256-7zrM2vmaikyClNgHHO8OXmATNpJtH85/CDv/86vwzZU=";
  };
  vendorHash = "sha256-YqduGY9c4zRQscjqze3ZOAB8EYj+0/6V7NceRwLe3DY=";

  buildInputs = [ sqlite ];

  buildPhase = ''
    runHook preBuild
    go build -o $GOPATH/bin/mobsql\
      -tags=sqlite_math_functions,libsqlite3 cli/*.go
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    HOME=$TMPDIR go test -tags=sqlite_math_functions,libsqlite3 ./...
    runHook postCheck
  '';

  meta = with lib; {
    description = "GTFS to SQLite import utility";
    longDescription = ''
      Mobsql is a Go library and command-line application
      which facilitates loading one or multiple Mobility Database
      source GTFS feed archives into a SQLite database.
      Its internal SQLite schema mirrors GTFS's spec but adds a feed_id field
      to each table (thus allowing multiple feeds to be loaded
      to the database simulatenously).
    '';
    homepage = "https://git.sr.ht/~mil/mobsql";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.McSinyx ];
    mainProgram = "mobsql";
    platforms = platforms.unix;
  };
}
