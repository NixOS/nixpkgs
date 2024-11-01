{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, withSpeech ? !stdenv.hostPlatform.isDarwin
, makeWrapper
, espeak-ng
}:

buildGoModule rec {
  pname = "mob";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = "mob";
    rev = "v${version}";
    hash = "sha256-+zNlxIvIvPyz0vA9IPaMzP8wfEXwNyRcvp45ohzoxQQ=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [ "-s" "-w" ];

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
