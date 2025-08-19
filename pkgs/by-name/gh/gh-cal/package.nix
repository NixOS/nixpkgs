{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "gh-cal";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-x9DekflZoXxH964isWCi6YuV3v/iIyYOuRYVgKaUBx0=";
  };

  cargoHash = "sha256-myfvPAeWuFHQcHXfkTYRfXVQ5ZBrdzQlaqHljbS0ppg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "GitHub contributions calender terminal viewer";
    homepage = "https://github.com/mrshmllow/gh-cal";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
    mainProgram = "gh-cal";
  };
}
