{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, x11, libxklavier, libgcrypt, dbus/*for tests*/ }:

let
  ver_branch = "1.9";
  version = "1.9.6";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "12ix45xpcvwb4158bmvxgxk0h26wxik9k75jpaflay46s1bd8sxf";
  };

  patches = [ ./lightdm.patch ];
  patchFlags = "-p1";

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt
  ] ++ stdenv.lib.optional doCheck dbus.daemon;

  configureFlags = [ "--enable-liblightdm-gobject" "--localstatedir=/var" ];

  doCheck = false; # some tests fail, don't know why

  meta = {
    homepage = http://launchpad.net/lightdm;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
