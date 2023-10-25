{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, openssl
, Security
, mpv
, ffmpeg
, nodejs
}:

rustPlatform.buildRustPackage rec {
  pname = "dmlive";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "0a07fd1b831bc9e9d34e474284430297b63446c7"; # no tag
    hash = "sha256-Jvxbdm9Swh8m03uZEMTkUhIHNfhE+N2a3w7j+liweKE=";
  };

  cargoHash = "sha256-/84T7K6WUt2Bfx9qdZjyOHcJEGoquCfRX1ctQBuUjEc=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram "$out/bin/dmlive" --prefix PATH : "${lib.makeBinPath [ mpv ffmpeg nodejs ]}"
  '';

  meta = with lib; {
    description = "A tool to play and record videos or live streams with danmaku";
    homepage = "https://github.com/THMonster/dmlive";
    license = licenses.mit;
    mainProgram = "dmlive";
    maintainers = with maintainers; [ nickcao ];
  };
}
