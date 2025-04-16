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
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = "mob";
    rev = "v${version}";
    hash = "sha256-OTKlasXswrZPfhdHD6tJt8z/e+BbgWa9LrKYhMbG/N4=";
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
