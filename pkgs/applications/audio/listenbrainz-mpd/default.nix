{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, stdenv
, openssl
, libiconv
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "listenbrainz-mpd";
  version = "2.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-DO7YUqaJZyVWjiAZ9WIVNTTvOU0qdsI2ct7aT/6O5dQ=";
  };

  cargoHash = "sha256-MiAalxe0drRHrST3maVvi8GM2y3d0z4Zl7R7Zx8VjEM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = if stdenv.isDarwin then [ libiconv Security ] else [ openssl ];

  meta = with lib; {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
