{
  stdenv,
  lib,
  fetchFromGitLab,
  makeWrapper,
  networkmanager,
  rofi-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "rofi-vpn";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "DamienCassou";
    repo = pname;
    rev = "v${version}";
    sha256 = "04jcfb2jy8yyrk4mg68krwh3zb5qcyj1aq1bwk96fhybrq9k2hhp";
  };

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-vpn

    wrapProgram $out/bin/rofi-vpn \
      --prefix PATH ":" ${
        lib.makeBinPath [
          rofi-unwrapped
          networkmanager
        ]
      }

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "Rofi-based interface to enable VPN connections with NetworkManager";
    homepage = "https://gitlab.com/DamienCassou/rofi-vpn";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
    mainProgram = "rofi-vpn";
  };
}
