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
  # Currently unsupported. According to upstream, libgovirt is for a very narrow
  # use-case and we don't currently cover it in Nixpkgs. It's safe to disable.
  # https://gitlab.com/virt-viewer/virt-viewer/-/issues/100#note_1265011223
  # Can be enabled again once this is merged:
  # https://gitlab.com/virt-viewer/virt-viewer/-/merge_requests/129
, ovirtSupport ? false
, libvirt
, libvirt-glib
, libxml2
, meson
, ninja
, pkg-config
, python3
, shared-mime-info
# https://gitlab.com/virt-viewer/virt-viewer/-/issues/88
, spice-gtk_libsoup2 ? null
, spice-protocol ? null
, spiceSupport ? true
, vte
, wrapGAppsHook
}:

assert spiceSupport -> (
  gdbm != null
  && (stdenv.isLinux -> libcap != null)
  && spice-gtk_libsoup2 != null
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
    # Fix build with meson 0.61
    # https://gitlab.com/virt-viewer/virt-viewer/-/merge_requests/117
    (fetchpatch {
      url = "https://gitlab.com/virt-viewer/virt-viewer/-/commit/ed19e51407bee53988878a6ebed4e7279d00b1a1.patch";
      sha256 = "sha256-3AbnkbhWOh0aNjUkmVoSV/9jFQtvTllOr7plnkntb2o=";
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
    libvirt
    libvirt-glib
    libxml2
    vte
  ] ++ optionals ovirtSupport [
    libgovirt
  ] ++ optionals spiceSupport ([
    gdbm
    spice-gtk_libsoup2
    spice-protocol
  ] ++ optionals stdenv.isLinux [
    libcap
  ]);

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = optional spiceSupport spice-gtk_libsoup2;

  mesonFlags = [
    (lib.mesonEnable "ovirt" ovirtSupport)
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build-aux/post_install.py
  '';

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
