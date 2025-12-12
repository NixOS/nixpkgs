{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  itstool,
  libxml2,
  meson,
  ninja,
  perl,
  python3,
  pkg-config,
  wrapGAppsHook3,
  at-spi2-core,
  dbus,
  elfutils,
  libepoxy,
  gexiv2,
  glib,
  gobject-introspection,
  gst_all_1,
  gtk3,
  lcms2,
  libdatrie,
  libgphoto2,
  libgudev,
  libpeas,
  libraw,
  libselinux,
  libsepol,
  lerc,
  libthai,
  libunwind,
  libxkbcommon,
  orc,
  udev,
  util-linux,
  xorg,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "entangle";
  version = "3.0";

  src = fetchFromGitLab {
    owner = "entangle";
    repo = "entangle";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "hz2WSDOjriQSavFlDT+35x1X5MeInq80ZrSP1WR/td0=";
  };

  patches = [
    # Switch to girepository-2.0
    # https://src.fedoraproject.org/rpms/libpeas1/pull-request/3
    ./girepository-2.0.patch

    # Fix build with meson 0.61, can be removed on next update
    # https://gitlab.com/entangle/entangle/-/issues/67
    (fetchpatch {
      url = "https://gitlab.com/entangle/entangle/-/commit/54795d275a93e94331a614c8712740fcedbdd4f0.patch";
      sha256 = "iEgqGjKa0xwSdctwvNdEV361l9nx+bz53xn3fuDgtzY=";
    })

    # Fix implicit dependency
    # https://github.com/NixOS/nixpkgs/issues/36468
    # https://gitlab.com/entangle/entangle/-/merge_requests/61
    ./0001-build-Add-missing-gio-unix-2.0-dependency.patch
  ];

  nativeBuildInputs = [
    itstool
    glib
    libxml2 # for xmllint
    meson
    ninja
    perl # for pod2man and build scripts
    python3 # for build scripts
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    at-spi2-core
    dbus
    libepoxy
    elfutils
    gexiv2
    glib
    lerc
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    lcms2
    libdatrie
    libgphoto2
    libgudev
    libpeas
    libraw
    libselinux
    libsepol
    libthai
    libunwind
    libxkbcommon
    orc
    udev
    util-linux
    zstd
  ]
  ++ (with xorg; [
    libXdmcp
    libXtst
  ]);

  # Disable building of doc/reference since it requires network connection to render XML to HTML
  # Patch build script shebangs
  postPatch = ''
    sed -i "/subdir('reference')/d" "docs/meson.build"
    patchShebangs --build build-aux meson_post_install.py
    sed -i meson_post_install.py \
      -e "/print('Update icon cache...')/d" \
      -e "/gtk-update-icon-cache/d"
  '';

  meta = {
    description = "Tethered camera control and capture";
    longDescription = ''
      Entangle uses GTK and libgphoto2 to provide a graphical interface
      for tethered photography with digital cameras.
      It includes control over camera shooting and configuration settings
      and 'hands off' shooting directly from the controlling computer.
      This app can also serve as a camera app for mobile devices.
    '';
    homepage = "https://gitlab.com/entangle/entangle";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "entangle";
  };
})
