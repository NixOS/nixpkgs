{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, stdenv
, openssl
, libiconv
, sqlite
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "listenbrainz-mpd";
  version = "2.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-AalZTlizaw93KlVffFDjGNoKkCHUFQTiElZgJo64shs=";
  };

  cargoHash = "sha256-n24P56ZrF8qEpM45uIFr7bJhlzuAexNr6siEsF219uA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ] ++ (if stdenv.isDarwin then [ libiconv Security ] else [ openssl ]);

  meta = with lib; {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
