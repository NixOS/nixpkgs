{
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  pkg-config,
  lib,
  cmake,
  u-config,
  gtkmm3,
  gtksourceviewmm,
  gtksourceview3,
  jsoncpp,
  libsysprof-capture,
  libselinux,
  libsepol,
  libdatrie,
  libthai,
  libxml2,
  libxkbcommon,
  libepoxy,
  libxdmcp,
  libxtst,
  systemdLibs,
  pcre2,
  util-linuxMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notekit";
  version = "0-unstable-2026-01-28";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "blackhole89";
    repo = "${finalAttrs.pname}";
    rev = "f53fa3b999cdd7a5efe264301eaadfdb7e969553";
    sha256 = "sha256-lXCwvDw7j7mPryqN7OI7jkneuBoNoLbNUP+Vm/q32RI=";
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  nativeBuildInputs = [
    u-config
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    gtksourceviewmm
    jsoncpp
    gtksourceview3
    libsysprof-capture # needed by glib's pkg-config metadata
    # GTK's pkg-config Requires.private graph isn't propagated fully when
    # strictDeps is enabled, so these providers must be visible explicitly.
    libselinux # required by gio's pkg-config metadata
    libsepol # required by libselinux's pkg-config metadata
    pcre2 # needed by glib's pkg-config metadata
    util-linuxMinimal # needed by glib's libmount pkg-config requirement
    libthai # required by pango's pkg-config metadata
    libdatrie # required by libthai's pkg-config metadata
    libxml2 # required by gtksourceview's pkg-config metadata
    libxtst # required by Notekit's CMake pkg-config check
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon # required by gtk's pkg-config metadata
    libepoxy # required by gtk's pkg-config metadata
    libxdmcp # required by xcb's pkg-config metadata
    systemdLibs # required by dbus's pkg-config metadata
  ];

  meta = {
    homepage = "https://github.com/blackhole89/${finalAttrs.pname}";
    description = "Hierarchical markdown notetaking application with tablet support";
    maintainers = [ lib.maintainers.philocalyst ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
