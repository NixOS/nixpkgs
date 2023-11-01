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
  version = "2.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-fFVhooRFtzatsF2sn6FUj3vAyKnAkodTWIfBWNcr+nw=";
  };

  cargoHash = "sha256-97ZPv4godg2VASe0I12YQIB8DsWGkvxoln13t1qwV1w=";

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
