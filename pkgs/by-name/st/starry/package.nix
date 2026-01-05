{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "starry";
  version = "2.0.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/ZUmMLEqlpqu+Ja/3XjFJf+OFZJCz7rp5MrQBEjwsXs=";
  };

  cargoHash = "sha256-NNQhU6NVacRCzFp2hWcBvHvD6zPOlTvII8n7k505HrY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Current stars history tells only half the story";
    homepage = "https://github.com/Canop/starry";
    license = licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "starry";
  };
}
