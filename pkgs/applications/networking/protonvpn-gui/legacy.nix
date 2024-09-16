{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  wrapGAppsHook3,
  gdk-pixbuf,
  glib-networking,
  gobject-introspection,
  imagemagick,
  librsvg,
  pango,
  python3,
  webkitgtk,
  # Python libs
  protonvpn-nm-lib,
  psutil,
  # Optionals
  withIndicator ? true,
  libappindicator-gtk3,
}:

buildPythonApplication rec {
  pname = "protonvpn-gui";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-app";
    rev = "refs/tags/${version}";
    sha256 = "sha256-MPS4d/yNkccsc/j85h7/4k4xL8uSCvhj/9JWPa7ezLY=";
  };

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    imagemagick
    setuptools
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    glib-networking # needed for the login captcha
    protonvpn-nm-lib
    psutil
  ];

  buildInputs = [
    librsvg
    pango
    webkitgtk
  ] ++ lib.optionals withIndicator [ libappindicator-gtk3 ];

  postInstall = ''
    # Setting icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize $size'x'$size \
        protonvpn_gui/assets/icons/protonvpn-logo.png \
        $out/share/icons/hicolor/$size'x'$size/apps/protonvpn.png
    done

    install -Dm644 protonvpn.desktop -t $out/share/applications/
    chmod 644 $out/${python3.sitePackages}/protonvpn_gui/assets/icons/plus-server.png
    substituteInPlace $out/share/applications/protonvpn.desktop \
      --replace 'protonvpn-logo' protonvpn
  '';

  # Project has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Official ProtonVPN Linux app";
    homepage = "https://github.com/ProtonVPN/linux-app";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    mainProgram = "protonvpn";
    platforms = platforms.linux;
  };
}
