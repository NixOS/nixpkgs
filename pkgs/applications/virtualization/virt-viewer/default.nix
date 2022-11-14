{ lib
, stdenv
, bash-completion
, fetchurl
, fetchpatch
, gdbm ? null
, glib
, gsettings-desktop-schemas
, gtk-vnc
, gtk3
, intltool
, libcap ? null
, libgovirt
, libvirt
, libvirt-glib
, libxml2
, meson
, ninja
, pkg-config
, python3
, shared-mime-info
  # https://gitlab.com/virt-viewer/virt-viewer/-/issues/88
, spice-gtk ? null
, spice-protocol ? null
, spiceSupport ? true
, vte
, wrapGAppsHook
}:

assert spiceSupport -> (
  gdbm != null
    && (stdenv.isLinux -> libcap != null)
    && spice-gtk != null
    && spice-protocol != null
);

with lib;

stdenv.mkDerivation rec {
  pname = "virt-viewer";
  version = "11.0";

  src = fetchurl {
    url = "https://releases.pagure.org/virt-viewer/virt-viewer-${version}.tar.xz";
    sha256 = "sha256-pD+iMlxMHHelyMmAZaww7wURohrJjlkPIjQIabrZq9A=";
  };

  patches = [
    # Fix build with libsoup 3 and meson 0.61
    (fetchpatch {
      url = "https://github.com/archlinux/svntogit-community/raw/895834eb7e811ca29b19b5812a2c412a5b705cf5/trunk/rest.diff";
      sha256 = "sha256-aOV/WOHT1L0N+o+L+qH8CibJQrtUVqCvBZBF1nZYwG0=";
    })
  ];

  nativeBuildInputs = [
    glib
    intltool
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    bash-completion
    glib
    gsettings-desktop-schemas
    gtk-vnc
    gtk3
    libgovirt
    libvirt
    libvirt-glib
    libxml2
    vte
  ] ++ optionals spiceSupport ([
    gdbm
    spice-gtk
    spice-protocol
  ] ++ optionals stdenv.isLinux [
    libcap
  ]);

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = optional spiceSupport spice-gtk;

  strictDeps = true;

  postPatch = ''
    patchShebangs build-aux/post_install.py
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = {
    description = "A viewer for remote virtual machines";
    maintainers = with maintainers; [ raskin atemu ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://virt-manager.org/download.html";
    };
  };
}
