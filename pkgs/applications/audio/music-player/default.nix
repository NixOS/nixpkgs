{ lib
, stdenv
, alsa-lib
, darwin
, fetchFromGitHub
, pkg-config
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "music-player";
  version = "0.2.0-alpha.13";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    rev = "v${version}";
    hash = "sha256-LuO64E5kJdMgd5h0+Sb8Wg7hxUmS8E7bKT3NIyd9+Lc=";
  };

  cargoHash = "sha256-Xn0OUHMgKxzDvhO+xRv5jMa50OzEtl6yhHbJ1R/a56Y=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ];

  meta = with lib; {
    description = "An extensible music player daemon written in Rust";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
