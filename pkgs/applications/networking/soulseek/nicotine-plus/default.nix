{ lib, fetchFromGitHub, python3Packages, gettext, gdk-pixbuf
, gobject-introspection, gtk3, wrapGAppsHook }:

with lib;

python3Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = version;
    sha256 = "sha256-NL6TXFRB7OeqNEfdANkEqh+MCOF1+ehR+6RO1XsIix8=";
  };

  nativeBuildInputs = [ gettext wrapGAppsHook ];

  propagatedBuildInputs = [ gtk3 gdk-pixbuf gobject-introspection ]
    ++ (with python3Packages; [ pygobject3 ]);

  postInstall = ''
    mv $out/bin/nicotine $out/bin/nicotine-plus
    substituteInPlace $out/share/applications/org.nicotine_plus.Nicotine.desktop \
      --replace "Exec=nicotine" "Exec=$out/bin/nicotine-plus"
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
