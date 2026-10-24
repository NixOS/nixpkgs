{
  stdenv,
  lib,
  fetchFromGitLab,
  makeWrapper,
  networkmanager,
  rofi-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-vpn";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "DamienCassou";
    repo = "rofi-vpn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F0IxE87LQ2fS5CtgFaRnuKw/IM8TmVfJzN4jL8VyTBI=";
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

  meta = {
    description = "Rofi-based interface to enable VPN connections with NetworkManager";
    homepage = "https://gitlab.com/DamienCassou/rofi-vpn";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DamienCassou ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi-vpn";
  };
})
