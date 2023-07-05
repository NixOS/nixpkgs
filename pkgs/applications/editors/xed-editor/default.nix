{ stdenv
, lib
, fetchFromGitHub
, libxml2
, libpeas
, glib
, gtk3
, gtksourceview4
, gspell
, xapp
, pkg-config
, python3
, meson
, ninja
, wrapGAppsHook
, intltool
, itstool
}:

stdenv.mkDerivation rec {
  pname = "xed-editor";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
    sha256 = "sha256-fTrvHf7iA3qexxdebSgzLXlngAOkdraW3KiVTVYodrY=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    intltool
    itstool
    ninja
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    gtksourceview4
    libpeas
    gspell
    xapp
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$($out/bin/xed --version)" == "xed - Version ${version}" ]] ; then
      echo "${pname} smoke test passed"
    else
      echo "${pname} smoke test failed"
      return 1
    fi
  '';

  meta = with lib; {
    description = "Light weight text editor from Linux Mint";
    homepage = "https://github.com/linuxmint/xed";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tu-maurice bobby285271 ];
  };
}
