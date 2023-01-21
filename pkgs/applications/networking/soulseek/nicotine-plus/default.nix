{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, gdk-pixbuf
, gettext
, gobject-introspection
, gtk3
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "nicotine-plus";
    repo = "nicotine-plus";
    rev = "refs/tags/${version}";
    sha256 = "sha256-/l31w7ohBgjeE+Ywuo7aaDZBzVNLFD3dqMRr/P3ge+s=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook gobject-introspection ];

  propagatedBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    gtk3
    python3Packages.pygobject3
  ];

  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A graphical client for the SoulSeek peer-to-peer system";
    longDescription = ''
      Nicotine+ aims to be a pleasant, free and open source (FOSS) alternative
      to the official Soulseek client, providing additional functionality while
      keeping current with the Soulseek protocol.
    '';
    homepage = "https://www.nicotine-plus.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry klntsky ];
  };
}
