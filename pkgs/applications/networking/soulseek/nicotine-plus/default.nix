{ lib, fetchFromGitHub, python3Packages, gettext, gdk-pixbuf
, gobject-introspection, gtk3, wrapGAppsHook }:

with lib;

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = version;
    hash = "sha256-3NXlNd3Zy++efnvcnfIOUP83mdJ5h8BmE4a2uWn5CPQ=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook ];

  propagatedBuildInputs = [ gtk3 gdk-pixbuf gobject-introspection ]
    ++ (with python3Packages; [ pygobject3 ]);


  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
    test -e $out/share/applications/org.nicotine_plus.Nicotine.desktop && exit 1
    install -D data/org.nicotine_plus.Nicotine.desktop -t $out/share/applications
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  doCheck = false;

  meta = {
    description = "A graphical client for the SoulSeek peer-to-peer system";
    homepage = "https://www.nicotine-plus.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry klntsky ];
    platforms = platforms.unix;
  };
}
