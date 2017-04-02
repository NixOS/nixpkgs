{ stdenv, fetchurl, itstool, python2Packages, intltool, wrapGAppsHook
, libxml2, gobjectIntrospection, gtk3, gnome3, cairo, file
}:


let
  minor = "3.16";
  version = "${minor}.4";
  inherit (python2Packages) python buildPythonApplication pycairo pygobject3;
in buildPythonApplication rec {
  name = "meld-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "0rwflfkfnb9ydnk4k591x0il29d4dvz95cjs2f279blx64lgki4k";
  };

  buildInputs = [
    intltool wrapGAppsHook itstool libxml2
    gnome3.gtksourceview gnome3.gsettings_desktop_schemas pycairo cairo
    gnome3.defaultIconTheme gnome3.dconf file
  ];
  propagatedBuildInputs = [ gobjectIntrospection pygobject3 gtk3 ];

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name/
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
    maintainers = [ maintainers.mimadrid ];
  };
}
