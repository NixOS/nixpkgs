{ lib, fetchFromGitHub, python3Packages, gettext, gdk-pixbuf
, gobject-introspection, gtk3, wrapGAppsHook }:

with lib;

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = version;
    hash = "sha256-E8b2VRlnMWmBHu919QDPBYuMbrjov9t//bHi1Y/F0Ak=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook ];

  propagatedBuildInputs = [ gtk3 gdk-pixbuf gobject-introspection ]
    ++ (with python3Packages; [ pygobject3 ]);

  postInstall = ''
    mv $out/bin/nicotine $out/bin/nicotine-plus
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
