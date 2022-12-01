{ stdenv
, lib
, fetchFromGitHub
, glib
, meson
, ninja
, wrapGAppsHook
, desktop-file-utils
, gobject-introspection
, gtk3
, python3
}:

stdenv.mkDerivation rec {
  pname = "siglo";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "theironrobin";
    repo = "siglo";
    rev = "v${version}";
    hash = "sha256-4jKsRpzuyHH31LXndC3Ua4TYcI0G0v9qqe0cbvLuCDA=";
  };

  patches = [
    ./siglo-no-user-install.patch
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py # patchShebangs requires an executable file
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    glib
    meson
    ninja
    wrapGAppsHook
    python3.pkgs.wrapPython
    python3
    desktop-file-utils
    gtk3
  ];

  buildInputs = [
    gtk3
    python3.pkgs.gatt
    gobject-introspection
  ];

  pythonPath = with python3.pkgs; [
    gatt
    pybluez
    requests
  ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "GTK app to sync InfiniTime watch with PinePhone";
    homepage = "https://github.com/theironrobin/siglo";
    changelog = "https://github.com/theironrobin/siglo/tags/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
