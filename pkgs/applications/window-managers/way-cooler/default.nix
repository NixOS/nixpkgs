{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig
, wayland, xwayland, wlc, dbus_libs, dbus_glib, cairo, libxkbcommon }:

with rustPlatform;

buildRustPackage rec {
  name = "way-cooler-${version}";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "way-cooler";
    repo = "way-cooler";
    rev = "v${version}";
    sha256 = "10s01x54kwjm2c85v57i6g3pvj5w3wpkjblj036mmd865fla1brb";
  };

  depsSha256 = "1k5xbw2zhm5z650mxdbxixr90im53wlpjdvq2pbnx2snqm84idlc";

  buildInputs = [ wlc dbus_libs dbus_glib cairo libxkbcommon ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Customizable Wayland compositor (window manager)";
    longDescription = ''
      Way Cooler is a customizable tiling window manager written in Rust
      for Wayland and configurable using Lua. It is heavily inspired by
      the tiling and extensibility of both i3 and awesome. While Lua is
      used for the configuration, like awesome, extensions for Way Cooler
      are implemented as totally separate client programs using D-Bus.
      This means that you can use virtually any language to extend the
      window manager, with much better guarantees about interoperability
      between extensions.
    '';
    homepage = http://way-cooler.org/;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.miltador ];
    platforms = platforms.all;
  };
}
