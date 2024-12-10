{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  withSpeech ? !stdenv.isDarwin,
  makeWrapper,
  espeak-ng,
}:

buildGoModule rec {
  pname = "mob";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uFtE7AprM/ye2sBQeszYy07RV7RmmqD9TGcTTuZwOfY=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  preFixup = lib.optionalString withSpeech ''
    wrapProgram $out/bin/mob \
      --set MOB_VOICE_COMMAND "${lib.getBin espeak-ng}/bin/espeak"
  '';

  meta = with lib; {
    description = "Tool for smooth git handover";
    mainProgram = "mob";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
  };
}
