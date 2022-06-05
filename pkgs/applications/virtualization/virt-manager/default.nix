{ lib, fetchFromGitHub, python3, intltool, file, wrapGAppsHook, gtk-vnc
, vte, avahi, dconf, gobject-introspection, libvirt-glib, system-libvirt
, gsettings-desktop-schemas, libosinfo, gnome, gtksourceview4, docutils, cpio
, e2fsprogs, findutils, gzip, cdrtools, xorriso, fetchpatch
, spiceSupport ? true, spice-gtk ? null
}:

python3.pkgs.buildPythonApplication rec {
  pname = "virt-manager";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3ycXNBuf91kI2cJCRw0ZzaWkaIVwb/lmkOKeHNwpH9Y=";
  };

  nativeBuildInputs = [
    intltool file
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    docutils
  ];

  buildInputs = [
    wrapGAppsHook
    libvirt-glib vte dconf gtk-vnc gnome.adwaita-icon-theme avahi
    gsettings-desktop-schemas libosinfo gtksourceview4
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
  ] ++ lib.optional spiceSupport spice-gtk;

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3 libvirt libxml2 requests cdrtools
  ];

   patches = [
     # due to a recent change in setuptools-61, "packages=[]" needs to be included
     # this patch can hopefully be removed, once virt-manager has an upstream version bump
    (fetchpatch {
      name = "fix-for-setuptools-61.patch";
      url = "https://github.com/virt-manager/virt-manager/commit/46dc0616308a73d1ce3ccc6d716cf8bbcaac6474.patch";
      sha256 = "sha256-/RZG+7Pmd7rmxMZf8Fvg09dUggs2MqXZahfRQ5cLcuM=";
    })
  ];

  postPatch = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python3.interpreter} setup.py configure --prefix=$out
  '';

  setupPyGlobalFlags = [ "--no-update-icon-cache" "--no-compile-schemas" ];

  dontWrapGApps = true;

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas

    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    # these are called from virt-install in initrdinject.py
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ cpio e2fsprogs file findutils gzip ]}")

    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    cpio
    cdrtools
    xorriso
  ];

  disabledTests = [
    "testAlterDisk"
    "test_misc_nonpredicatble_generate"
  ];

  preCheck = ''
    export HOME=.
  ''; # <- Required for "tests/test_urldetect.py".

  postCheck = ''
    $out/bin/virt-manager --version | grep -Fw ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "http://virt-manager.org";
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
