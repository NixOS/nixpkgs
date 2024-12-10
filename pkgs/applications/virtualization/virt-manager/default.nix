{
  lib,
  fetchFromGitHub,
  python3,
  intltool,
  file,
  wrapGAppsHook3,
  gtk-vnc,
  vte,
  avahi,
  dconf,
  gobject-introspection,
  libvirt-glib,
  system-libvirt,
  gsettings-desktop-schemas,
  gst_all_1,
  libosinfo,
  gnome,
  gtksourceview4,
  docutils,
  cpio,
  e2fsprogs,
  findutils,
  gzip,
  cdrtools,
  xorriso,
  fetchpatch,
  desktopToDarwinBundle,
  stdenv,
  spiceSupport ? true,
  spice-gtk ? null,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "virt-manager";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UgZ58WLXq0U3EDt4311kv0kayVU17In4kwnQ+QN1E7A=";
  };

  patches = [
    # refresh Fedora tree URLs in virt-install-osinfo* expected XMLs
    (fetchpatch {
      url = "https://github.com/virt-manager/virt-manager/commit/6e5c1db6b4a0af96afeb09a09fb2fc2b73308f01.patch";
      hash = "sha256-zivVo6nHvfB7aHadOouQZCBXn5rY12nxFjQ4FFwjgZI=";
    })
    # fix test with libvirt 10
    (fetchpatch {
      url = "https://github.com/virt-manager/virt-manager/commit/83fcc5b2e8f2cede84564387756fe8971de72188.patch";
      hash = "sha256-yEk+md5EkwYpP27u3E+oTJ8thgtH2Uy1x3JIWPBhqeE=";
    })
    # fix crash with some cursor themes
    (fetchpatch {
      url = "https://github.com/virt-manager/virt-manager/commit/cc4a39ea94f42bc92765eb3bb56e2b7f9198be67.patch";
      hash = "sha256-dw6yrMaAOnTh8Z6xJQQKmYelOkOl6EBAOfJQU9vQ8Ws=";
    })
  ];

  nativeBuildInputs = [
    intltool
    file
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    docutils
    wrapGAppsHook3
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libvirt-glib
    vte
    dconf
    gtk-vnc
    gnome.adwaita-icon-theme
    avahi
    gsettings-desktop-schemas
    libosinfo
    gtksourceview4
  ] ++ lib.optional spiceSupport spice-gtk;

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    libvirt
    libxml2
    requests
    cdrtools
  ];

  postPatch = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python3.interpreter} setup.py configure --prefix=$out
  '';

  setupPyGlobalFlags = [
    "--no-update-icon-cache"
    "--no-compile-schemas"
  ];

  dontWrapGApps = true;

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas

    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    # these are called from virt-install in initrdinject.py
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        cpio
        e2fsprogs
        file
        findutils
        gzip
      ]
    }")

    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    # Fixes testCLI0051virt_install_initrd_inject on Darwin: "cpio: root:root: invalid group"
    substituteInPlace virtinst/install/installerinject.py \
      --replace "'--owner=root:root'" "'--owner=0:0'"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytest7CheckHook
    cpio
    cdrtools
    xorriso
  ];

  disabledTests = [
    "testAlterDisk"
    "test_misc_nonpredicatble_generate"
    "test_disk_dir_searchable" # does something strange with permissions
    "testCLI0001virt_install_many_devices" # expects /var to exist
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  ''; # <- Required for "tests/test_urldetect.py".

  postCheck = ''
    $out/bin/virt-manager --version | grep -Fw ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://virt-manager.org";
    description = "Desktop user interface for managing virtual machines";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "virt-manager";
    maintainers = with maintainers; [
      qknight
      offline
      fpletz
      globin
    ];
  };
}
