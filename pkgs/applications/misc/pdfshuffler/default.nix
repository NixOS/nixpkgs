{ stdenv, fetchsvn
, wrapGAppsHook, makeWrapper, gettext
, python3Packages, gtk3, poppler_gi
, gnome3, gsettings-desktop-schemas, shared-mime-info,
}:

python3Packages.buildPythonApplication rec {
  name = "pdfshuffler-unstable-2017-02-26"; # no official release in 5 years

  src = fetchsvn {
    url = "http://svn.gna.org/svn/pdfshuffler/trunk";
    rev = "20";
    sha256 = "1g20dy45xg5vda9y58d2b1gkczj44xgrfi59jx6hr62ynd3z0dfc";
  };

  nativeBuildInputs = [ wrapGAppsHook gettext makeWrapper ];

  buildInputs = [
    gtk3 gsettings-desktop-schemas poppler_gi gnome3.adwaita-icon-theme
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pycairo
    pypdf2
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  doCheck = false; # no tests

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/pdfshuffler/wiki/Home;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages";
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
    license = licenses.gpl3;
  };
}
