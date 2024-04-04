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
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = pname;
    rev = "3736d83ac0920de78ac82fe331bc6b16dc72b5cd"; # no tag
    hash = "sha256-3agUeAv6Nespn6GNw4wmy8HNPQ0VIgZAMnKiV/myKbA=";
  };

  cargoHash = "sha256-MxkWaEn/gMMOuje7lu7PlqsQjnF0LWpV9JzmFBG1ukU=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ configd Security ];

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
