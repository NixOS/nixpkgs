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
  version = "0.7.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ytAKINcZwLyHWbzShxfxRKx4BepM0G2BYdLgwR48g7w=";
  };

  cargoHash = "sha256-yxFF5Yqj+xTB3FAJUtgcIeAEHR44JA1xONxGFdG0yS0=";

  patches = [
    (fetchpatch {
      name = "fix-panic-when-XDG_AUDIO_DIR-not-set.patch";
      url = "https://github.com/tramhao/termusic/commit/b6006b22901f1f865a2e3acf7490fd3fa520ca5e.patch";
      hash = "sha256-1ukQ0y5IRdOndsryuqXI9/zyhCDQ5NIeTan4KCynAv0=";
    })
  ];

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
