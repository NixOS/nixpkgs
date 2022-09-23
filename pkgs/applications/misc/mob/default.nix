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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "remotemobprogramming";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qr6F98OVI+K0V59YH35GERiC9jgxp/YJm4N4EGvDotk=";
  };

  vendorSha256 = null;

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
