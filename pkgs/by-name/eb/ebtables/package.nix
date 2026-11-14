{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ebtables";
  version = "2.0.11";

  src = fetchurl {
    url = "https://ftp.netfilter.org/pub/ebtables/ebtables-${finalAttrs.version}.tar.gz";
    sha256 = "0apxgmkhsk3vxn9q3libxn3dgrdljrxyy4mli2gk49m7hi3na7xp";
  };

  # Fix build with linux-headers 7.3
  patches = [
    (fetchpatch {
      url = "https://lore.kernel.org/netfilter-devel/CAD04=wrZafKknWixGGRZWtYD_ydfdL4Uk39s_RkwZ6WUEVATKg@mail.gmail.com/2-0001-include-drop-bundled-copy-of-linux-types.h.patch";
      hash = "sha256-bEOXZTK557fVfRDrgd0RZX2N3XJxJG78S/MnvdG0UqY=";
    })
  ];

  makeFlags = [
    "LIBDIR=$(out)/lib"
    "BINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man"
    "ETCDIR=$(out)/etc"
    "INITDIR=$(TMPDIR)"
    "SYSCONFIGDIR=$(out)/etc/sysconfig"
    "LOCALSTATEDIR=/var"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  preInstall = "mkdir -p $out/etc/sysconfig";

  postInstall = ''
    ln -s $out/sbin/ebtables-legacy          $out/sbin/ebtables
    ln -s $out/sbin/ebtables-legacy-restore  $out/sbin/ebtables-restore
    ln -s $out/sbin/ebtables-legacy-save     $out/sbin/ebtables-save
  '';

  meta = {
    description = "Filtering tool for Linux-based bridging firewalls";
    homepage = "http://ebtables.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
