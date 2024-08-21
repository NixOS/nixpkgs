{
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  jdupes,
  lib,
  sassc,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lavanda-gtk-theme";
  version = "2024-04-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Lavanda-gtk-theme";
    rev = version;
    hash = "sha256-2ryhdgLHSNXdV9QesdB0rpXkr3i2vVqXWDDC5fNuL1c=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall

    bash install.sh -d $out/share/themes

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lavanda gtk theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Lavanda-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dretyuiop ];
  };
}
