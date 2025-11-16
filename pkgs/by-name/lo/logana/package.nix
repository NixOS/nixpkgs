{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "logana";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "emilycares";
    repo = "logana";
    tag = version;
    hash = "sha256-Ke5QTJutGB4f4tnH8CekDXVA1CDU9jkIlGiBhnLxb5c=";
  };

  cargoHash = "sha256-usn4tk4fdiu5dvbwF/8HnJOWH5OWtETXBHpUj/0GbZw=";

  meta = {
    description = "Build log analysis tool";
    homepage = "https://github.com/emilycares/logana";
    mainProgram = "logana";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emilycares ];
  };
}
