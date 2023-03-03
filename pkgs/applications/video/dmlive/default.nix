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
  version = "unstable-2022-11-19";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "711319043dca3c1fee44cd60841ef51605b42bce";
    hash = "sha256-weWl9voqTP/1ZBSLuMFzfWE5NskHNPJnFYy9n9IgcZk=";
  };

  cargoHash = "sha256-9bonyOCQfO5Eq8T2GVCri+INCe4RUOK28nw4cnmmAWs=";

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
