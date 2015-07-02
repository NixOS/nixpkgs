{ stdenv, fetchurl, itstool, buildPythonPackage, python27, intltool, makeWrapper
, libxml2, pygobject3, gobjectIntrospection, gtk3, gnome3, pycairo, cairo
, hicolor_icon_theme
}:


let
  minor = "3.12";
  version = "${minor}.3";
in

buildPythonPackage rec {
  name = "meld-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "1zg6qhm53j0vxmjj3pcj2hwi8c12dxzmlh98zks0jnwhqv2p4dfv";
  };

  buildInputs = [
    python27 intltool makeWrapper itstool libxml2
    gnome3.gtksourceview gnome3.gsettings_desktop_schemas pycairo cairo
    hicolor_icon_theme
  ];
  propagatedBuildInputs = [ gobjectIntrospection pygobject3 gtk3 ];

  installPhase = ''
    mkdir -p "$out/lib/${python27.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python27.libPrefix}/site-packages:$PYTHONPATH"

    ${python27}/bin/${python27.executable} setup.py install \
      --install-lib=$out/lib/${python27.libPrefix}/site-packages \
      --prefix="$out"

    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name/
  '';

  preFixup = ''
    wrapProgram $out/bin/meld \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  patchPhase = ''
    sed -e 's,#!.*,#!${python27}/bin/python27,' -i bin/meld
  '';

  pythonPath = [ gtk3 ];

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = http://meld.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
