{ stdenv
, lib
, fetchFromGitHub
, cmake
, libxml2
, libpeas
, glib
, gtk3
, gtksourceview4
, gspell
, xapps
, pkg-config
, meson
, ninja
, wrapGAppsHook
, intltool
, itstool }:

stdenv.mkDerivation rec {
  pname = "xed-editor";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
    sha256 = "sha256-PW7y3+Sa9FH5r5xvziysvxM08RJCPvnLs3wsm5IqToQ=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    intltool
    itstool
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    gtksourceview4
    libpeas
    gspell
    xapps
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

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
    maintainers = with maintainers; [ tu-maurice ];
  };
}
