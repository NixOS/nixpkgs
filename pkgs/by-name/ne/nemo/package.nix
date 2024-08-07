{ fetchFromGitHub
, glib
, gobject-introspection
, meson
, ninja
, pkg-config
, lib
, stdenv
, wrapGAppsHook3
, libxmlb
, gtk3
, gvfs
, cinnamon-desktop
, xapp
, libexif
, json-glib
, exempi
, intltool
, shared-mime-info
, cinnamon-translations
, libgsf
, python3
}:

let
  # For action-layout-editor.
  pythonEnv = python3.withPackages (pp: with pp; [
    pycairo
    pygobject3
    python-xapp
  ]);
in
stdenv.mkDerivation rec {
  pname = "nemo";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-3FALXfW0PzWuirX7bxP8BFkIRyQzvg3xBQCdddSpmOg=";
  };

  patches = [
    # Load extensions from NEMO_EXTENSION_DIR environment variable
    # https://github.com/NixOS/nixpkgs/issues/78327
    ./load-extensions-from-env.patch
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib
    gtk3
    cinnamon-desktop
    libxmlb # action-layout-editor
    pythonEnv
    xapp
    libexif
    exempi
    gvfs
    libgsf
    json-glib
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wrapGAppsHook3
    intltool
    shared-mime-info
    gobject-introspection
  ];

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  postInstall = ''
    # This fixes open as root and handles nemo-with-extensions well.
    # https://github.com/NixOS/nixpkgs/issues/297570
    substituteInPlace $out/share/polkit-1/actions/org.nemo.root.policy \
      --replace-fail "$out/bin/nemo" "/run/current-system/sw/bin/nemo"
  '';

  preFixup = ''
    # Used for some non-fd.o icons (e.g. xapp-text-case-symbolic)
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${xapp}/share"
    )
  '';

  # Taken from libnemo-extension.pc.
  passthru.extensiondir = "lib/nemo/extensions-3.0";

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
    mainProgram = "nemo";
  };
}

