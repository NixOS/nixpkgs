{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "askalono";
  version = "0.5.0";

  src = fetchCrate {
    pname = "askalono-cli";
    inherit version;
    hash = "sha256-LwyUaU4m9fk+mG8FBfkbj9nBvd8KokwlV7cE7EBwk0Q=";
  };

  cargoHash = "sha256-7yFdoXK9Nyg1uT0mtiXs6evOu1U1quxL7iMMMyxqxqk=";

  meta = with lib; {
    description = "Tool to detect open source licenses from texts";
    homepage = "https://github.com/jpeddicord/askalono";
    changelog = "https://github.com/jpeddicord/askalono/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "askalono";
  };
}
