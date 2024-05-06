{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "starry";
  version = "2.0.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/ZUmMLEqlpqu+Ja/3XjFJf+OFZJCz7rp5MrQBEjwsXs=";
  };

  cargoHash = "sha256-L6s1LkWnjht2VLwq1GOFiIosnZjFN9tDSLpPtokmj9o=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Current stars history tells only half the story";
    homepage = "https://github.com/Canop/starry";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starry";
  };
}
