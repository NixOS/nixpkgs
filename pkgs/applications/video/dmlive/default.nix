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
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "53c55cb3c087bc00a882331307d210c2965b04d1"; # no tag
    hash = "sha256-k15IjNGiY0ISEyWxlhZST4dtink/OtoJtv4/8nUn7qY=";
  };

  cargoHash = "sha256-0zOwqxD3WX/4e19ywpghdfoGmh2KC+70HbTSYkVHzUA=";

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
