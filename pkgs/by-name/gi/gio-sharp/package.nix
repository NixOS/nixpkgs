{ lib, stdenv, fetchFromGitHub, autoconf, automake, which, pkg-config, mono, glib, gtk-sharp-2_0 }:

stdenv.mkDerivation rec {
  pname = "gio-sharp";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gio-sharp";

    rev = version;
    sha256 = "13pc529pjabj7lq23dbndc26ssmg5wkhc7lfvwapm87j711m0zig";
  };

  nativeBuildInputs = [ pkg-config autoconf automake which ];
  buildInputs = [ mono glib gtk-sharp-2_0 ];

  dontStrip = true;

  prePatch = ''
    ./autogen-2.22.sh
  '';

  meta = with lib; {
    description = "GIO API bindings";
    homepage = "https://github.com/mono/gio-sharp";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
