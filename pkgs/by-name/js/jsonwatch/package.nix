{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonwatch";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "jsonwatch";
    tag = "v${version}";
    hash = "sha256-qhVqAhUAbLb5wHnLNHr6BxffyH1G5B09eOJQoqSzWEk=";
  };

  cargoHash = "sha256-D29pmt97DYfpYa9EwK+IlggR3zQFGzOy/Ky01UGI3tg=";

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
