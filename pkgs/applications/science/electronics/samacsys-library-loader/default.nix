{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, cairo
, gtk3
, glib
, which
, wrapGAppsHook
}:
rustPlatform.buildRustPackage rec {
  pname = "samacsys-library-loader";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "olback";
    repo = "library-loader";
    rev = version;
    sha256 = "sha256-NUWLfP2+qAH2Y8Wj8ifL8MJrI8XCIeovp9wN2VEgZeU=";
    leaveDotGit = true;
  };

  cargoSha256 = "sha256:0cc2azymki7phbdj6jk2yfhspifvszq3czh34iqm74lnm09xr27f";

  nativeBuildInputs = [
    pkg-config
    which
    glib.dev
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    gtk3
    glib
  ];

  postInstall = ''
    install -m 444 -D $src/ll-gui/library-loader-gui.desktop \
      $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Icon=/usr/share/icons/hicolor/scalable/apps/net.olback.LibraryLoader.svg' 'Icon=${pname}' \
      --replace 'Exec=library-loader-gui' "Exec=$out/bin/library-loader-gui"

    install -m 444 -D $src/ll-gui/assets/library-loader-icon.svg \
      $out/share/icons/hicolor/scalable/apps/${pname}.svg
  '';

  meta = with lib; {
    description = "Unofficial Samacsys PCB Part Library Loader for ECAD";
    homepage = "https://github.com/olback/library-loader";
    license = licenses.agpl3;
    maintainers = [ maintainers.stargate01 ];
  };
}
