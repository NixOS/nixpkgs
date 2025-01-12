{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  docutils,
  desktopToDarwinBundle,
  gtk-vnc,
  vte,
  dconf,
  gobject-introspection,
  libvirt-glib,
  gsettings-desktop-schemas,
  libosinfo,
  adwaita-icon-theme,
  gtksourceview4,
  xorriso,
  spiceSupport ? true,
  spice-gtk ? null,
  gst_all_1 ? null,
}:

let
  pythonDependencies = with python3.pkgs; [
    pygobject3
    libvirt
    libxml2
    requests
  ];
in
stdenv.mkDerivation rec {
  pname = "virt-manager";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KtB2VspkA/vFu7I8y6M8WfAoZglxmCeb4Z3OzdsGuvk=";
  };

  strictDeps = true;
  mesonFlags = [
    (lib.mesonBool "compile-schemas" false)
    (lib.mesonEnable "tests" false)
  ];

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    docutils
    wrapGAppsHook4
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs =
    [
      python3
      libvirt-glib
      vte
      dconf
      gtk-vnc
      adwaita-icon-theme
      gsettings-desktop-schemas
      libosinfo
      gtksourceview4
    ]
    ++ lib.optionals spiceSupport [
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      spice-gtk
    ];
  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas

    gappsWrapperArgs+=(--set PYTHONPATH "${python3.pkgs.makePythonPath pythonDependencies}")
    # these are called from virt-install in installerinject.py
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xorriso ]}")

    patchShebangs $out/bin
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
      fpletz
      globin
    ];
  };
}
