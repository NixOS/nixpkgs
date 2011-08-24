{ stdenv, fetchgit, fetchgitrevision
, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs, automoc4, phonon
, strigi, soprano, qca2, libmtp, liblastfm, libgpod, pkgconfig
, repository ? "git://git.kde.org/amarok"
, branch ? "heads/master"
, rev ? fetchgitrevision repository branch
, src ? fetchgit {
    url = repository;
    rev = rev;
  }
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "live";

  inherit src;

  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";
  buildInputs = [ cmake qt4 qtscriptgenerator perl stdenv.gcc.libc gettext curl
    libxml2 mysql taglib taglib_extras loudmouth kdelibs automoc4 phonon strigi
    soprano qca2 libmtp liblastfm libgpod pkgconfig ];

  postInstall = ''
    mkdir -p $out/nix-support
    echo ${qtscriptgenerator} > $out/nix-support/propagated-user-env-packages
  '';
  meta = {
    description = "Popular music player for KDE";
    license = "GPL";
    homepage = http://amarok.kde.org;
    inherit (kdelibs.meta) maintainers;
  };
}
