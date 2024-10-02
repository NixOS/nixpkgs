{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  sqlite,
}:

buildGoModule rec {
  pname = "mobroute";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mobroute";
    rev = "v${version}";
    hash = "sha256-/+qypWQFx4Oqh2KRzTc7whnmWYJngwbpOAa6Z7xmgeo=";
  };
  vendorHash = "sha256-Sp5S2nBaIOn91SrJifwP1aDe0Uq/1Lgo1VI51cl5bX0=";

  buildInputs = [ sqlite ];
  tags = [
    "libsqlite3"
    "sqlite_math_functions"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/{cli,mobroute}
  '';

  meta = with lib; {
    description = "General purpose public transportation router based on GTFS";
    longDescription = ''
      Mobroute is a general purpose public transportation router
      (e.g. trip planner) Go library and CLI that works
      by directly ingesting timetable (GTFS) data from transit agencies
      (sourced from the Mobility Database).  After data has been fetched,
      routing calculations can be run offline.

      Overall, Mobroute aims to offer an opensource framework
      for integrating data-provider-agnostic GTFS public transit capabilities
      (integrated GTFS ETL, GTFS multisource support, and routing algorithm)
      into applications to get users from point-a to point-b via public transit
      without comprising privacy or user freedoms.
    '';
    homepage = "https://git.sr.ht/~mil/mobroute";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.McSinyx ];
    mainProgram = "mobroute";
    platforms = platforms.unix;
  };
}
