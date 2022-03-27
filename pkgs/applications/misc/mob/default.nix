{ lib
, buildGoPackage
, fetchFromGitHub
, stdenv
, withSpeech ? !stdenv.isDarwin
, makeWrapper
, espeak-ng
}:

buildGoPackage rec {
  pname = "mob";
  version = "3.0.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-silAgScvhl388Uf6HkWqEkNmr/K6aUt/lj/rxzkk/f0=";
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
