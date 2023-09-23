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
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "92ce90163c3d84f0fab99e6dc192a65c616ffd81"; # no tag
    hash = "sha256-3eRC/XmvZXe3DyXOqSkNpTbddtGr/lcaTaFYqZLZq+w=";
  };

  cargoHash = "sha256-TQTdz+ZC5cZxWhccnUmXnq+j2EYM5486mIjn6Poe5a8=";

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
