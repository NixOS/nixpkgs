{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  openssh,
  procps,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmc";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "TimidRobot";
    repo = "cmc";
    tag = finalAttrs.version;
    hash = "sha256-BJYXXyj3RmmKG6pficPbsqhDmBwcrHlvQhEK5Ptv1qo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp cmc $out/bin/cmc
    wrapProgram $out/bin/cmc \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          openssh
          procps
        ]
      }
  '';
  meta = {
    homepage = "https://github.com/TimidRobot/cmc";
    description = "Manages SSH ControlMaster sessions";
    mainProgram = "cmc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ chordtoll ];
    platforms = lib.platforms.all;
  };
})
