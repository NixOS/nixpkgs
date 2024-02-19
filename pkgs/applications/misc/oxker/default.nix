{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-cUM9+6BZcsrb850fm5mFWpo7/JmxwNDh+upHeE7+DU8=";
  };

  cargoHash = "sha256-sFBI/+7oGjjUyr3PBkkqdgprGdcaYHtOvqFpkrF4Qx8=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
