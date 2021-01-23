{ at-spi2-core, cmake, dbus, dbus-glib, docbook_xsl, epoxy, fetchpatch, fetchFromGitHub
, glib, gtk3, harfbuzz, libXdmcp, libXtst, libpthreadstubs
, libselinux, libsepol, libtasn1, libxkbcommon, libxslt, p11-kit, pcre2
, pkg-config, lib, stdenv, util-linuxMinimal, vte, wrapGAppsHook, xmlto
}:

stdenv.mkDerivation rec {
  pname = "roxterm";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "realh";
    repo = "roxterm";
    rev = version;
    sha256 = "042hchvgk9jzz035zsgnfhh8105zvspbzz6b78waylsdlgqn0pp1";
  };

  patches = [
    # This is the commit directly after v3.7.5.  It is needed to get roxterm to
    # build correctly.  It can be removed when v3.7.6 (or v3.8.0) has been
    # released.
    (fetchpatch {
      url = "https://github.com/realh/roxterm/commit/f7c38fd48bd1810e16d82794bdfb61a9760a2fe1.patch";
      sha256 = "1v77b7ilgf8zy1npxxcyc06mq6lck6bi6lw4aksnq3mi61n5znmx";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook libxslt ];

  buildInputs =
    [ gtk3 dbus dbus-glib vte pcre2 harfbuzz libpthreadstubs libXdmcp
      util-linuxMinimal glib docbook_xsl xmlto libselinux
      libsepol libxkbcommon epoxy at-spi2-core libXtst libtasn1 p11-kit
    ];

  meta = with lib; {
    homepage = "https://github.com/realh/roxterm";
    license = licenses.gpl3;
    description = "Tabbed, VTE-based terminal emulator";
    longDescription = ''
      Tabbed, VTE-based terminal emulator. Similar to gnome-terminal without
      the dependencies on Gnome.
    '';
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
