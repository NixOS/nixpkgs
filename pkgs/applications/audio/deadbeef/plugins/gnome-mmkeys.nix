{ lib, stdenv, fetchurl, pkg-config, deadbeef, glib }:

stdenv.mkDerivation {
  pname = "deadbeef-gnome-mmkeys";
  version = "2019-03-16";

  src = fetchurl {
    url = "https://github.com/zhanghai/deadbeef-gnome-mmkeys/archive/895deabd56405cdc71a93418ffb101bb5e35dcfe.tar.gz";
    sha256 = "08vwsriazpwk4dy9p2if217rfwy69cbbaw6a3zky1g3hbvmfplk8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ deadbeef glib ];

  installPhase = "make install INSTALL_DIR=$out/lib/deadbeef";

  meta = with lib; {
    description = "DeaDBeeF player GNOME (via DBus) multimedia keys plugin";
    homepage = "https://github.com/zhanghai/deadbeef-gnome-mmkeys/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
