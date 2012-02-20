{ stdenv, fetchurl, lib, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs
, qca2, libmtp, liblastfm, libgpod, pkgconfig, automoc4, phonon
, strigi, soprano }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0jc8fsrhshgfv441b2dgqk0wz3ms5bzjqchcj5ydxphg57dr3l8y";
  };

  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";
  buildInputs = [ qtscriptgenerator stdenv.gcc.libc gettext curl
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
