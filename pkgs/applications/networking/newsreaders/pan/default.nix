{ spellChecking ? true
, stdenv, fetchurl, pkgconfig, gtk, gtkspell ? null
, perl, pcre, gmime, gettext
}:

assert spellChecking -> gtkspell != null /* !!! && gtk == gtkspell.gtk */;
# !!! assert gtk.glib == gnet.glib;

stdenv.mkDerivation {
  name = "pan-0.132";

  src = fetchurl {
    url = http://pan.rebelbase.com/download/releases/0.132/source/pan-0.132.tar.bz2;
    sha1 = "dc0bf586145b9d617039f49101874fbc76a9dc18";
  };

  patches = [
    # Patch to build Pan on recent glibs.
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/net-nntp/pan/files/pan-0.132-glib-compat.patch?rev=1.1";
      sha256 = "0bmgnc3l1pz763xns8057qbsjirc0njr8dn34fhy4ig9yk4kp9k7";
    })
  ];

  buildInputs = [
    pkgconfig gtk perl pcre gmime gettext
    (if spellChecking then gtkspell else null)
  ];

  inherit spellChecking stdenv;

  meta = {
    description = "A GTK+-based Usenet newsreader good at both text and binaries";
  };
}
