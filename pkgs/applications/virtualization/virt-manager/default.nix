{ stdenv, fetchurl, python3Packages, intltool, file
, wrapGAppsHook, gtk-vnc, vte, avahi, dconf
, gobject-introspection, libvirt-glib, system-libvirt
, gsettings-desktop-schemas, glib, libosinfo, gnome3
, gtksourceview4
, spiceSupport ? true, spice-gtk ? null
, cpio, e2fsprogs, findutils, gzip
}:

with stdenv.lib;

# TODO: remove after there's support for setupPyDistFlags
let
  setuppy = ../../../development/interpreters/python/run_setup.py;
in
python3Packages.buildPythonApplication rec {
  name = "virt-manager-${version}";
  version = "2.2.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "06ws0agxlip6p6n3n43knsnjyd91gqhh2dadgc33wl9lx1k8vn6g";
  };

  nativeBuildInputs = [
    intltool file
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
  ];

  buildInputs = [
    wrapGAppsHook
    libvirt-glib vte dconf gtk-vnc gnome3.adwaita-icon-theme avahi
    gsettings-desktop-schemas libosinfo gtksourceview4
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
  ] ++ optional spiceSupport spice-gtk;

  propagatedBuildInputs = with python3Packages;
    [
      pygobject3 ipaddress libvirt libxml2 requests
    ];

  patchPhase = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python3Packages.python.interpreter} setup.py configure --prefix=$out
  '';

  # TODO: remove after there's support for setupPyDistFlags
  buildPhase = ''
    runHook preBuild
    cp ${setuppy} nix_run_setup
    ${python3Packages.python.pythonForBuild.interpreter} nix_run_setup --no-update-icon-cache build_ext bdist_wheel
    runHook postBuild
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    # these are called from virt-install in initrdinject.py
    gappsWrapperArgs+=(--prefix PATH : "${makeBinPath [ cpio e2fsprogs file findutils gzip ]}")
  '';

  # Failed tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://virt-manager.org;
    description = "Desktop user interface for managing virtual machines";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = licenses.gpl2;
    # exclude Darwin since libvirt-glib currently doesn't build there
    platforms = platforms.linux;
    maintainers = with maintainers; [ qknight offline fpletz globin ];
  };
}
