{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig
, wayland, xwayland, wlc, dbus_libs, dbus_glib, cairo, libxkbcommon
, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "way-cooler-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "way-cooler";
    repo = "way-cooler";
    rev = "v${version}";
    sha256 = "16zswn17c11piby899ciq386m7h7vjvr96f75l35qiswkmwb83kj";
  };

  cargoSha256 = "1b1mzjicgz1s0gvxq0d54l7r8jnyl0yzmv801n78yl4hwmmf7clv";

  buildInputs = [ wlc dbus_libs dbus_glib cairo libxkbcommon wayland makeWrapper ];

  nativeBuildInputs = [ pkgconfig ];

  postInstall = ''
    mkdir -p $out/libexec
    mv $out/bin/way-cooler $out/libexec
    makeWrapper $out/libexec/way-cooler $out/bin/way-cooler --prefix LD_LIBRARY_PATH : ${wayland}/lib
  '';

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
