{ lib
, buildGoPackage
, fetchFromGitHub

, withSpeech ? true
, makeWrapper
, espeak-ng
}:

buildGoPackage rec {
  pname = "mob";
  version = "2.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-K8ID8cetzCaMc/PVRNMyIhrshtEUiD6U/jI4e0TcOO4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  goPackagePath = "github.com/remotemobprogramming/mob";

  preFixup = lib.optionalString withSpeech ''
    wrapProgram $out/bin/mob \
      --set MOB_VOICE_COMMAND "${lib.getBin espeak-ng}/bin/espeak"
  '';

  meta = with lib; {
    description = "Tool for smooth git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
