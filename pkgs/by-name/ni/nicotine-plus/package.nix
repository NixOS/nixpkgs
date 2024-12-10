{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  gdk-pixbuf,
  gettext,
  gobject-introspection,
  gtk4,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "nicotine-plus";
    repo = "nicotine-plus";
    rev = "refs/tags/${version}";
    hash = "sha256-6tA3d+QX2ArDH4aeWZNKuIXe3Sk32JaFe8d0C8G9Akc=";
  };

  nativeBuildInputs = [
    gettext
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    gtk4
    python3Packages.pygobject3
  ];

  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk4}/share/gsettings-schemas/${gtk4.name}"
    )
  '';

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
    maintainers = with maintainers; [ klntsky ];
  };
}
