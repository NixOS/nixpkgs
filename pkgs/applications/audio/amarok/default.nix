{ stdenv, fetchurl, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs, automoc4, phonon
, strigi, soprano, qca2, libmtp, liblastfm, libgpod, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "52be0e926d1362828a4bf64e2a174dc009c85f6f33da4ca589f0f09ab9b7085c";
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
