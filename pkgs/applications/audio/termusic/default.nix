{ lib
, stdenv
, rustPlatform
, fetchCrate
, fetchpatch
, pkg-config
, alsa-lib
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-m0hi5u4BcRcEDEpg1BoWXc25dfhD6+OJtqSZfSdV0HM=";
  };

  cargoHash = "sha256-A83gLsaPm6t4nm7DJfcp9z1huDU/Sfy9gunP8pzBiCA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
