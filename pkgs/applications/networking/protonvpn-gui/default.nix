{ lib, fetchFromGitHub, gobject-introspection, imagemagick,
wrapGAppsHook, python3Packages, gtk3, networkmanager, webkitgtk }:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-gui";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-app";
    rev = version;
    sha256 = "sha256-08gXEKm8udgNltRdqvAMFL0pDCWZu/kfl1xGQtZPBCc=";
  };

  strictDeps = false;

  nativeBuildInputs = [
    gobject-introspection imagemagick wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    protonvpn-nm-lib
    psutil
  ];

  buildInputs = [
    gtk3 networkmanager webkitgtk
  ];

  postFixup = ''
    # Setting icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize $size'x'$size \
        protonvpn_gui/assets/icons/protonvpn-logo.png \
        $out/share/icons/hicolor/$size'x'$size/apps/protonvpn.png
    done

    install -Dm644 protonvpn.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/protonvpn.desktop \
      --replace 'protonvpn-logo' protonvpn
  '';

  # Project has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Linux GUI for ProtonVPN, written in Python";
    homepage = "https://github.com/ProtonVPN/linux-app";
    maintainers = with maintainers; [ offline wolfangaukang ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
