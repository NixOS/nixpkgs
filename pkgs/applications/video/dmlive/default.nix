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
  version = "unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "fd4fa1859f05350658db598a50d29f59d22b55a1";
    hash = "sha256-NVabHLxPHi7hWoztthPmVC5VRKQKglpytuUQOY1Hzrw=";
  };

  cargoHash = "sha256-TziP7n9Xgi/wHaiF/NI6noMp1iR6vRuAXxvKJwQHbTw=";

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
    maintainers = with maintainers; [ nickcao ];
  };
}
