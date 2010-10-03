{ stdenv, fetchurl, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs, automoc4, phonon
, strigi, soprano, qca2, libmtp, liblastfm, libgpod, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0dw2928vkd42h3d8nsb8i4xhp8qfj1zsfc1m9wrzrsxl0vd6j9c4";
  };

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
    inherit (kdelibs.meta) platforms maintainers;
  };
}
