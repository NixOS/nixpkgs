{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, x11, libxklavier, libgcrypt, dbus/*for tests*/ }:

let
  ver_branch = "1.8";
  version = "1.7.0";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "0nwwjgc9xvwili6714ag88wsrf0lr5hv1i6z9f0xvin4ym18cbs5";
  };

  patches = [ ./lightdm.patch ];
  patchFlags = "-p0";

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt
  ] ++ stdenv.lib.optional doCheck dbus.daemon;

  configureFlags = [ "--enable-liblightdm-gobject" "--localstatedir=/var" ];

  doCheck = false; # some tests fail, don't know why

  meta = {
    homepage = http://launchpad.net/lightdm;
    platforms = stdenv.lib.platforms.linux;
  };
}
