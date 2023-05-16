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
<<<<<<< HEAD
  version = "5.3.0";
=======
  version = "5.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
<<<<<<< HEAD
    rev = "92ce90163c3d84f0fab99e6dc192a65c616ffd81"; # no tag
    hash = "sha256-3eRC/XmvZXe3DyXOqSkNpTbddtGr/lcaTaFYqZLZq+w=";
  };

  cargoHash = "sha256-TQTdz+ZC5cZxWhccnUmXnq+j2EYM5486mIjn6Poe5a8=";
=======
    rev = "53c55cb3c087bc00a882331307d210c2965b04d1"; # no tag
    hash = "sha256-k15IjNGiY0ISEyWxlhZST4dtink/OtoJtv4/8nUn7qY=";
  };

  cargoHash = "sha256-0zOwqxD3WX/4e19ywpghdfoGmh2KC+70HbTSYkVHzUA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    mainProgram = "dmlive";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ nickcao ];
  };
}
