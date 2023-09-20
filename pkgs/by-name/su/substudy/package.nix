{ lib
, fetchFromGitHub
, rustPlatform

, ffmpeg
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "substudy";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "emk";
    repo = "subtitles-rs";
    rev = "${pname}_v${version}";
    hash = "sha256-fx/Oaylh4XRjlgLJrICyADfyilFU+6INEEwdm+PB6WA=";
  };

  cargoHash = "sha256-AaopA555LJVLb8HFMHkYnAbQjuT02sSiHvTNG84H7wU=";

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeCheckInputs = [
    ffmpeg
  ];

  postFixup = ''
    wrapProgram "$out/bin/substudy" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    description = "Learn foreign languages using audio and subtitles extracted from video files";
    homepage = "http://www.randomhacks.net/substudy";
    license = licenses.cc0;
    mainProgram = "substudy";
    maintainers = with maintainers; [ paveloom ];
  };
}
