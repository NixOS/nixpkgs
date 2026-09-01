{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphite-cursors";
  version = "2021-11-26";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "graphite-cursors";
    rev = finalAttrs.version;
    sha256 = "sha256-Kopl2NweYrq9rhw+0EUMhY/pfGo4g387927TZAhI5/A=";
  };

  installPhase = ''
    install -dm 755 $out/share/icons
    mv dist-dark $out/share/icons/graphite-dark
    mv dist-light $out/share/icons/graphite-light
    mv dist-dark-nord $out/share/icons/graphite-dark-nord
    mv dist-light-nord $out/share/icons/graphite-light-nord
  '';

  meta = {
    description = "Graphite cursor theme";
    homepage = "https://github.com/vinceliuice/Graphite-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ oluceps ];
  };
})
