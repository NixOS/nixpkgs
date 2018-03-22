/* Beware!
After starting Guake it will give the error message "Guake can not init! Gconf Error. Have you installed guake.schemas properly?",
which will have to be resolved manually, because I have not found a way to automate this, without being impure.

If you have Guake installed, you can use `nix-build -A gnome3.guake` to get the path to the build directory in the nix store,
which then can be used in the following command to install the schemas file of Guake:
gconftool-2 --install-schema-file /path/returned/by/nix-build/share/gconf/schemas/guake.schemas

It can be removed again by the following command:
gconftool-2 --recursive-unset /apps/guake
*/
{ stdenv, fetchurl, lib
, pkgconfig, libtool, intltool, makeWrapper
, dbus, gtk2, gconf, python2Packages, libutempter, vte, keybinder, gnome2, gnome3 }:

with lib;

let
  inherit (python2Packages) python;
  inputs = [ dbus gtk2 gconf python libutempter vte keybinder gnome3.gnome-common ];
  pyPath = makeSearchPathOutput "lib" python.sitePackages (attrVals [ "dbus-python" "notify" "pyGtkGlade" "pyxdg" ] python2Packages ++ [ gnome2.gnome_python ]);
 in stdenv.mkDerivation rec {
  name = "guake-${version}";
  version = "0.8.3";

  src = fetchurl {
    url = "https://github.com/Guake/guake/archive/${version}.tar.gz";
    sha256 = "1lbmdz3i9a97840h8239s360hd37nmhy3hs6kancxbzl1512ak1y";
  };

  nativeBuildInputs = [ pkgconfig libtool intltool makeWrapper ];

  buildInputs = inputs ++ (with python2Packages; [ pyGtkGlade pyxdg ]);

  propagatedUserEnvPkgs = [ gconf.out ];

  patchPhase = ''
    patchShebangs .
  '';

  configureScript = "./autogen.sh";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-schemas-install"
  ];

  installFlags = [
    # Configuring the installation to not install gconf schemas is not always supported,
    # therefore gconftool-2 has this variable, which will make gconftool-2 not update any of the databases.
    "GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1"
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  postInstall = ''
    mkdir -p $out/share/gconf/schemas
    cp data/guake.schemas $out/share/gconf/schemas
  '';

  postFixup = ''
    for bin in $out/bin/{guake,guake-prefs}; do
      substituteInPlace $bin \
        --replace '/usr/bin/env python2' ${python.interpreter}
      wrapProgram $bin \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix LD_LIBRARY_PATH : ${makeLibraryPath inputs} \
        --prefix PYTHONPATH : "$out/${python.sitePackages}:${pyPath}:$PYTHONPATH"
    done
  '';

  meta = {
    description = "Drop-down terminal for GNOME";
    homepage = http://guake-project.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
