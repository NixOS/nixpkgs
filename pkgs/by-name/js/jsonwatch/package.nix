{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonwatch";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "jsonwatch";
    tag = "v${version}";
    hash = "sha256-HSyavdH3zhzEvk5qW5fiv8wqmgYsLUyx6Q6oEIOk5to=";
  };

  cargoHash = "sha256-2CtB8TEn0bieT0S2w3cm4nLZWdFcIymvWSOnWDTXEJc=";

  meta = with lib; {
    description = "Like watch -d but for JSON";
    longDescription = ''
      jsonwatch is a command line utility with which you can track
      changes in JSON data delivered by a shell command or a web
      (HTTP/HTTPS) API. jsonwatch requests data from the designated
      source repeatedly at a set interval and displays the
      differences when the data changes.
    '';
    homepage = "https://github.com/dbohdan/jsonwatch";
    changelog = "https://github.com/dbohdan/jsonwatch/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "jsonwatch";
  };
}
