{
  stdenv,
  fetchFromGitLab,
  lib,
  makeWrapper,
  ponymix,
  rofi-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-pulse-select";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "DamienCassou";
    repo = "rofi-pulse-select";
    rev = finalAttrs.version;
    sha256 = "1405v0bh2m8ip9c23l95i8iq2gfrpanc6f4dz17nysdcff2ay2p3";
  };

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-pulse-select

    wrapProgram $out/bin/rofi-pulse-select \
      --prefix PATH ":" ${
        lib.makeBinPath [
          rofi-unwrapped
          ponymix
        ]
      }

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = {
    description = "Rofi-based interface to select source/sink (aka input/output) with PulseAudio";
    mainProgram = "rofi-pulse-select";
    homepage = "https://gitlab.com/DamienCassou/rofi-pulse-select";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DamienCassou ];
    platforms = lib.platforms.linux;
  };
})
