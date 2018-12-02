{ stdenv, fetchurl, itstool, python3Packages, intltool, wrapGAppsHook
, libxml2, gobject-introspection, gtk3, gnome3, cairo, file
}:


let
  pname = "meld";
  version = "3.18.3";
  inherit (python3Packages) python buildPythonApplication pycairo pygobject3;
in buildPythonApplication rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0vn1qx60f8113x8wh7f4bflhzir1vx7p0wdfi7nbip6fh8gaf3ln";
  };

  buildInputs = [
    intltool wrapGAppsHook itstool libxml2
    gnome3.gtksourceview gnome3.gsettings-desktop-schemas pycairo cairo
    gnome3.defaultIconTheme gnome3.dconf file
  ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 gtk3 ];

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

  doCheck = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = http://meldmerge.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ maintainers.mimadrid ];
  };
}
