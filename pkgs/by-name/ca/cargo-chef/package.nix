{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.69";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zDVolVllWl0DM0AByglKhU8JQpkdcmyVGe1vYo+eamk=";
  };

  cargoHash = "sha256-RyPomJJbI67izQMuKf6fBSbM6Ar9Wm4oHYqnOnP/b8U=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
