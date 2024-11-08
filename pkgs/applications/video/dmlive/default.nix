{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, makeWrapper
, openssl
, configd
, Security
, mpv
, ffmpeg
, nodejs
}:

rustPlatform.buildRustPackage rec {
  pname = "dmlive";
  version = "5.5.4";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "688ddda12ed70a7ad25ede63e948e1cba143a307"; # no tag
    hash = "sha256-M7IZ2UzusWovyhigyUXasmSEz4J79gnFyivHVUqfUKg=";
  };

  cargoHash = "sha256-d3vI2iv2Db1XZQc3uaNfkUpDyNKPvHkb/0zEwRTOWZ0=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ configd Security ];

  postInstall = ''
    wrapProgram "$out/bin/dmlive" --prefix PATH : "${lib.makeBinPath [ mpv ffmpeg nodejs ]}"
  '';

  meta = with lib; {
    description = "Tool to play and record videos or live streams with danmaku";
    homepage = "https://github.com/THMonster/dmlive";
    license = licenses.mit;
    mainProgram = "dmlive";
    maintainers = with maintainers; [ nickcao ];
  };
}
