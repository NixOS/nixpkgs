{ stdenv, fetchurl, itstool, buildPythonApplication, python27, intltool, makeWrapper
, libxml2, pygobject3, gobjectIntrospection, gtk3, gnome3, pycairo, cairo
}:


let
  minor = "3.14";
  version = "${minor}.0";
in

buildPythonApplication rec {
  name = "meld-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "0g0h9wdr6nqdalqkz4r037569apw253cklwr17x0zjc7nwv2j3j3";
  };

  buildInputs = [
    python27 intltool makeWrapper itstool libxml2
    gnome3.gtksourceview gnome3.gsettings_desktop_schemas pycairo cairo
    gnome3.defaultIconTheme
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
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  patchPhase = ''
    patchShebangs bin/meld
  '';

  pythonPath = [ gtk3 ];

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = http://meldmerge.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
