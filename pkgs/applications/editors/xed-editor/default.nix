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
<<<<<<< HEAD
  version = "3.4.3";
=======
  version = "3.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-nc8YS1PcmtM37TJpGl691SlxJliyI2gSGJtNzkWbk9A=";
=======
    sha256 = "sha256-ax769qjV0oZ6tnEE5FsXNbHETI6KNgvh0WviBsPs9j8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
