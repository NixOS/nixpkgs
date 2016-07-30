{ stdenv, fetchurl, itstool, buildPythonApplication, python27, intltool, wrapGAppsHook
, libxml2, pygobject3, gobjectIntrospection, gtk3, gnome3, pycairo, cairo, file
}:


let
  minor = "3.16";
  version = "${minor}.2";
in

buildPythonApplication rec {
  name = "meld-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "2dd3f58b95444bf721e0c912668c29cf8f47a402440b772ea12c4b9a0c94966f";
  };

  buildInputs = [
    python27 intltool wrapGAppsHook itstool libxml2
    gnome3.gtksourceview gnome3.gsettings_desktop_schemas pycairo cairo
    gnome3.defaultIconTheme gnome3.dconf file
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
