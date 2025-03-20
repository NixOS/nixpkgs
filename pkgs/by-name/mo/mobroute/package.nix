{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  sqlite,
  stdenv,
}:

buildGoModule rec {
  pname = "mobroute";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mobroute";
    rev = "v${version}";
    hash = "sha256-eMLn9Px6jO88CQWpwFF7JK1UPHoEbhDXoU2G1aYe2dw=";
  };
  vendorHash = "sha256-fMIa9HCfK6YDb0V0RhzomwuSqPhlwLBHJRjQV96cY8g=";

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
