{ stdenv, fetchurl, firefox, libX11, xproto }:

stdenv.mkDerivation rec {
  name = "mozplugger-${version}";
  version = "2.1.6";

  src = fetchurl {
    url = "http://mozplugger.mozdev.org/files/mozplugger-${version}.tar.gz";
    sha256 = "1vszkq4kdbaxsrqr2xn9rq6ipza9fngdri79gvjqk3bvsdmg0k19";
  };

  buildInputs = [ firefox libX11 xproto ];

  installPhase = ''
    mkdir -p "$out/etc" "$out/bin" "$out/lib/mozilla/plugins" "$out/share/man/man7"
    cp mozpluggerrc "$out/etc"
    cp mozplugger-{helper,controller,linker,update} "$out/bin"
    cp mozplugger.so "$out/lib/mozilla/plugins"
    cp mozplugger.7 "$out/share/man/man7"

    mkdir -p "$out/share/${name}/plugin"
    ln -s "$out/lib/mozilla/plugins/mozplugger.so" "$out/share/${name}/plugin"
  '';

  meta = {
    description = "Mozilla plugin for launching external program for handling in-page objects";
    homepage = http://mozplugger.mozdev.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
