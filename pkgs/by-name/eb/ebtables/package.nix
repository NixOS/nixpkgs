{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ebtables";
  version = "2.0.11";

  src = fetchurl {
    url = "http://ftp.netfilter.org/pub/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0apxgmkhsk3vxn9q3libxn3dgrdljrxyy4mli2gk49m7hi3na7xp";
  };

  makeFlags = [
    "LIBDIR=$(out)/lib" "BINDIR=$(out)/sbin" "MANDIR=$(out)/share/man"
    "ETCDIR=$(out)/etc" "INITDIR=$(TMPDIR)" "SYSCONFIGDIR=$(out)/etc/sysconfig"
    "LOCALSTATEDIR=/var"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  preInstall = "mkdir -p $out/etc/sysconfig";

  postInstall = ''
    ln -s $out/sbin/ebtables-legacy          $out/sbin/ebtables
    ln -s $out/sbin/ebtables-legacy-restore  $out/sbin/ebtables-restore
    ln -s $out/sbin/ebtables-legacy-save     $out/sbin/ebtables-save
  '';

  meta = with lib; {
    description = "Filtering tool for Linux-based bridging firewalls";
    homepage = "http://ebtables.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
