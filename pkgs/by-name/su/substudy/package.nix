{
  lib,
  fetchFromGitHub,
  rustPlatform,

  ffmpeg,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "substudy";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "emk";
    repo = "subtitles-rs";
    rev = "substudy_v${version}";
    hash = "sha256-ACYbSQKaOJ2hS8NbOAppfKo+Mk3CKg0OAwb56AH42Zs=";
  };

  cargoHash = "sha256-S+/Oh1Cwulw8FyakF+d2E51AioFuQBGMAOG3y27YM2Q=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ ffmpeg ];

  cargoBuildFlags = [ "-p substudy" ];

  preCheck = ''
    # That's to make sure the `test_ai_request_static`
    # test has access to the cache at `$HOME/.cache`
    export HOME=$(mktemp -d)
  '';

  postFixup = ''
    wrapProgram "$out/bin/substudy" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    description = "Learn foreign languages using audio and subtitles extracted from video files";
    homepage = "https://www.randomhacks.net/substudy";
    license = licenses.asl20;
    mainProgram = "substudy";
    maintainers = with maintainers; [ ];
  };
}
