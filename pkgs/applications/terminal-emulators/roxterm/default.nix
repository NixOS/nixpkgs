{ at-spi2-core, cmake, dbus, dbus-glib, docbook_xsl, libepoxy, fetchFromGitHub
, glib, gtk3, harfbuzz, libXdmcp, libXtst, libpthreadstubs
, libselinux, libsepol, libtasn1, libxkbcommon, libxslt, p11-kit, pcre2
, pkg-config, lib, stdenv, util-linuxMinimal, vte, wrapGAppsHook, xmlto, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "roxterm";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "realh";
    repo = "roxterm";
    rev = version;
    sha256 = "sha256-IHJ30qXNVv9tUdePskHl1hd5kPivBb2kH1oOstBr/9s=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook libxslt ];

  buildInputs =
    [ gtk3 dbus dbus-glib vte pcre2 harfbuzz libpthreadstubs libXdmcp
      util-linuxMinimal glib docbook_xsl xmlto libselinux
      libsepol libxkbcommon libepoxy at-spi2-core libXtst libtasn1 p11-kit
    ];

  passthru.tests.test = nixosTests.terminal-emulators.roxterm;

  meta = with lib; {
    homepage = "https://github.com/realh/roxterm";
    license = licenses.gpl3;
    description = "Tabbed, VTE-based terminal emulator";
    longDescription = ''
      Tabbed, VTE-based terminal emulator. Similar to gnome-terminal without
      the dependencies on Gnome.
    '';
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
