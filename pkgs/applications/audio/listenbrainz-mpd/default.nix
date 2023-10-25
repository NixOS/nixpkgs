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
  version = "2.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-9o0PsmOkanPcES3y8NvvEOA/lsUU1vtKQAqBQwQtazk=";
  };

  cargoHash = "sha256-z7L6VQmCYo4YoEmwrvNU3u3UxnLkAqPgFBqJv4K1N1k=";

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
