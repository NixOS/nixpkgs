{ stdenv, fetchurl, autoconf, automake, pkgconfig
, libX11, libXinerama, libXft, pango
, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "0.15.5";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/archive/${version}.tar.gz";
    sha256 = "16dffwxqxcx5krb6v1m6gh0r6d0a4hwl0jq4fdyblcv9xid5hxf5";
  };

  buildInputs = [ autoconf automake pkgconfig libX11 libXinerama libXft pango
                ] ++ stdenv.lib.optional i3Support i3;

  preConfigure = ''
    autoreconf -vif
  '';

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.mbakke ];
  };
}
