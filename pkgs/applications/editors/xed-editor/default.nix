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
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
    sha256 = "sha256-MXRxzmRo/dRhp5Llib9ng1gzWW8uvzqTMjUVK8a3eJ8=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
  ];

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
    mainProgram = "xed";
  };
}
