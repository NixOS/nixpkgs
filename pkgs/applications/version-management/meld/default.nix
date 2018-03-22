{ stdenv, fetchurl, itstool, python3Packages, intltool, wrapGAppsHook
, libxml2, gobjectIntrospection, gtk3, gnome3, cairo, file
}:


let
  pname = "meld";
  version = "3.18.0";
  inherit (python3Packages) python buildPythonApplication pycairo pygobject3;
in buildPythonApplication rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0gi2jzgsrd5q2icyp6wphbn532ddg82nxhfxlffkniy7wnqmi0c4";
  };

  buildInputs = [
    intltool wrapGAppsHook itstool libxml2
    gnome3.gtksourceview gnome3.gsettings-desktop-schemas pycairo cairo
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
