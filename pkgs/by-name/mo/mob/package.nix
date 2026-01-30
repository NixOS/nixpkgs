{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  withSpeech ? !stdenv.hostPlatform.isDarwin,
  makeWrapper,
  espeak-ng,
}:

buildGoModule rec {
  pname = "mob";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = "mob";
    rev = "v${version}";
    hash = "sha256-zb2/uTFlzaR0AFElsYSjwYP2H4p05fDLK02A3awzIFY=";
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

  meta = {
    description = "Tool for smooth git handover";
    mainProgram = "mob";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ericdallo ];
  };
}
