{ stdenv
, fetchFromGitLab
, lib
, makeWrapper
, ponymix
, rofi-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "rofi-pulse-select";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "DamienCassou";
    repo = pname;
    rev = version;
    sha256 = "1405v0bh2m8ip9c23l95i8iq2gfrpanc6f4dz17nysdcff2ay2p3";
  };

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-pulse-select

    wrapProgram $out/bin/rofi-pulse-select \
      --prefix PATH ":" ${lib.makeBinPath [ rofi-unwrapped ponymix ]}

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "Rofi-based interface to select source/sink (aka input/output) with PulseAudio";
    mainProgram = "rofi-pulse-select";
    homepage = "https://gitlab.com/DamienCassou/rofi-pulse-select";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
  };
}
