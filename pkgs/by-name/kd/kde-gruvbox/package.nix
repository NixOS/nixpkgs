{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "kde-gruvbox";
  version = "0-unstable-2015-08-09";

  src = fetchFromGitHub {
    owner = "printesoi";
    repo = "kde-gruvbox";
    rev = "2dd95283076d7194345a460edb3630cfd020759c";
    sha256 = "sha256-ppAeEfwoHZg7XEj3zGc+uq4Z6hUgJNM2EjuDsc8pFQo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{plasma/desktoptheme,yakuake/kns_skins}
    cp -R color-schemes konsole $out/share
    cp -R plasma5/gruvbox $out/share/plasma/desktoptheme
    cp -R yakuake/breeze-gruvbox-dark $out/share/yakuake/kns_skins

    runHook postInstall
  '';

  meta = with lib; {
    description = "Suite of themes for KDE applications that match the retro gruvbox colorscheme";
    homepage = "https://github.com/printesoi/kde-gruvbox";
    license = licenses.mit;
    maintainers = [ maintainers.ymarkus ];
    platforms = platforms.all;
  };
}
