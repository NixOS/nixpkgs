{
  lib,
  python3,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  gtk3,
  gst_all_1,
  libnotify,
  librsvg,
  meson,
  ninja,
  pkg-config,
  slop,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "recapp";
  version = "1.1.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "amikha1lov";
    repo = "RecApp";
    rev = "v${version}";
    sha256 = "08bpfcqgw0lj6j7y5b2i18kffawlzp6pfk4wdpmk29vwmgk9s9yc";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk3
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    libnotify
    librsvg
    gtk3
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pulsectl
    pydbus
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${
        lib.makeBinPath [
          gst_all_1.gstreamer.dev
          slop
        ]
      }"
    )
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux written in GTK";
    homepage = "https://github.com/amikha1lov/RecApp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "recapp";
  };
}
