{ stdenv, fetchgit, cmake, vala, pkgconfig, gtk3, gnome3, sqlite, json_glib, tox, libsodium }:

let
  date = "20140605";
  rev  = "91b1f357e4df25818a7a34c260f4dae55b966446";
in
stdenv.mkDerivation {
  name = "venom-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = git://github.com/naxuroqa/Venom.git;
    inherit rev;
    sha256 = "106m4iiykg4hjamxha6v8mjj8vi59gl3584nvlv6qab8fz6y86s2";
  };

  buildInputs = [ cmake vala pkgconfig gtk3 gnome3.libgee sqlite json_glib tox libsodium ];

  meta = {
    description = "Vala/Gtk+ graphical user interface for Tox";
    license = stdenv.lib.licenses.gpl3;
    homepage = https://github.com/naxuroqa/Venom;
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}