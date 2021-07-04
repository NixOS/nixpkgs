{ lib
, python3Packages
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, imagemagick
, gtk3
, withIndicator ? true
, libappindicator-gtk3
}:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-gui-official";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-app";
    rev = version;
    sha256 = "081f7bdbi1j3nkm0kf3flpaj0xvfwgnn0svbqpqgnqc1bjycag5y";
  };

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection imagemagick ];

  buildInputs = [ gtk3 ]
    ++ lib.optionals withIndicator [ libappindicator-gtk3 ];

  propagatedBuildInputs = with python3Packages; [
    protonvpn-nm-lib
    pygobject3
    psutil
  ];

  strictDeps = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Fails loading tests even though project has no tests
  # Disabled until tests are added upstream
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/applications
    cp protonvpn.desktop $out/share/applications

    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" \
        protonvpn_gui/assets/icons/protonvpn-logo.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/protonvpn-logo.png
    done
  '';

  meta = with lib; {
    description = "ProtonVPN Linux App";
    homepage = "https://github.com/ProtonVPN/linux-app";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nkje ];
    platforms = platforms.linux;
  };
}
