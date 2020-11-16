{ stdenv
, fetchurl
, cmake
, pkgconfig
, gtk3
, perl
, vte
, pcre2
, glib
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "sakura";
  version = "3.7.1";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${version}/+download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-cppODnUKQpS9kFkkOqxU3yqAElAVn8VQtQsP4Carkos=";
  };

  nativeBuildInputs = [ cmake perl pkgconfig makeWrapper ];

  buildInputs = [ gtk3 vte pcre2 glib ];

  # Set path to gsettings-schemata so sakura knows
  # where to find colorchooser, fontchooser etc.
  postInstall = ''
    wrapProgram $out/bin/sakura \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  passthru.tests.test = nixosTests.terminal-emulators.sakura;

  meta = with stdenv.lib; {
    homepage = "https://www.pleyades.net/david/projects/sakura";
    description = "A terminal emulator based on GTK and VTE";
    longDescription = ''
      sakura is a terminal emulator based on GTK and VTE. It's a terminal
      emulator with few dependencies, so you don't need a full GNOME desktop
      installed to have a decent terminal emulator. Current terminal emulators
      based on VTE are gnome-terminal, XFCE Terminal, TermIt and a small
      sample program included in the vte sources. The differences between
      sakura and the last one are that it uses a notebook to provide several
      terminals in one window and adds a contextual menu with some basic
      options. No more no less.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astsmtl codyopel AndersonTorres ];
    platforms = platforms.linux;
 };
}
