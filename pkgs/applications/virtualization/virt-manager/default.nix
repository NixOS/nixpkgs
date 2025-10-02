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
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "virt-manager";
    repo = "virt-manager";
    rev = "v${version}";
    hash = "sha256-nMWLDo2pfWcqsVuEk0JbzLZ1a0lViTohsZ8gEXGhBuI=";
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
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
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

  postInstall = ''
    if ! grep -q StartupWMClass= "$out/share/applications/virt-manager.desktop"; then
        echo "StartupWMClass=.virt-manager-wrapped" >> "$out/share/applications/virt-manager.desktop"
    else
        echo "error: upstream desktop file already contains StartupWMClass=, please update Nix expr" >&2
        exit 1
    fi
  '';

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/virt-manager-${version}/glib-2.0/schemas

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
