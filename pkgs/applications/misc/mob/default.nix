{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, withSpeech ? !stdenv.isDarwin
, makeWrapper
, espeak-ng
}:

buildGoModule rec {
  pname = "mob";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ovp+JsNqFcOMk054khSdvPebFsv/fQD1Ghox8J3YcgA=";
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
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
  };
}
