{ stdenv, fetchurl, cmake, vala, pkgconfig, gtk3, gnome3, sqlite, json_glib, sodium, libtoxcore, libqrencode
, qrcodeSupport ? true }:

assert qrcodeSupport -> libqrencode != null;

let
  date = "20140605";
  version = "91b1f357";
in
stdenv.mkDerivation rec {
  name = "venom-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/naxuroqa/Venom/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "1fsg6yqjnh199vqwipvcshr8wqw49xpc0l1ramhpf80xaci08v3b";
  };

  buildInputs = [
    cmake vala pkgconfig gtk3 gnome3.libgee sqlite json_glib sodium libtoxcore 
  ] ++ stdenv.lib.optional qrcodeSupport [ libqrencode ];

  cmakeFlags = ''
    ${stdenv.lib.optionalString qrcodeSupport "-DENABLE_QR_ENCODE=ON"}
  '';

  meta = {
    description = "Vala/Gtk+ graphical user interface for Tox";
    homepage = https://github.com/naxuroqa/Venom;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}