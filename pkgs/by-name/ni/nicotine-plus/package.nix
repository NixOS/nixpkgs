{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  gdk-pixbuf,
  gettext,
  gobject-introspection,
  gtk4,
  glib,
  python3Packages,
  libadwaita,
}:
python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.3.7";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "nicotine-plus";
    repo = "nicotine-plus";
    tag = version;
    hash = "sha256-Rj+dDkBXNV4l4A9LxjBApzBQ4c1edP5XjoPfpifkDoM=";
  };

  nativeBuildInputs = [
    gettext
    wrapGAppsHook4
    gobject-introspection
    glib
    gdk-pixbuf
    gtk4
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  build-system = [
    python3Packages.setuptools
  ];

  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
  '';

  dontWrapGAppsHook = true;
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  doCheck = false;
  meta = with lib; {
    description = "Graphical client for the SoulSeek peer-to-peer system";
    longDescription = ''
      Nicotine+ aims to be a pleasant, free and open source (FOSS) alternative
      to the official Soulseek client, providing additional functionality while
      keeping current with the Soulseek protocol.
    '';
    homepage = "https://www.nicotine-plus.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      klntsky
      amadaluzia
    ];
  };
}
