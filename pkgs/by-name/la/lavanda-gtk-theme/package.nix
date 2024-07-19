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
  version = "2023-10-22";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Lavanda-gtk-theme";
    rev = version;
    hash = "sha256-J243VVEqzg6o5dYLSCKPxWhUj5EKCnhvCHdia8EIfeQ=";
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
