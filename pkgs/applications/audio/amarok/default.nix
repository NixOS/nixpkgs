{ stdenv, fetchurl, lib, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs
, qca2, libmtp, liblastfm, libgpod, pkgconfig, automoc4, phonon
, strigi, soprano, qjson, ffmpeg, libofa, nepomuk_core ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "1ilf9wdp3wna5pmvxill8x08rb9gw86qkc2zwm3xk9hpy8l9pf7l";
  };

  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";

  buildInputs = [ qtscriptgenerator stdenv.gcc.libc gettext curl
    libxml2 mysql taglib taglib_extras loudmouth kdelibs automoc4 phonon strigi
    soprano qca2 libmtp liblastfm libgpod pkgconfig qjson ffmpeg libofa nepomuk_core ];

  cmakeFlags = "-DKDE4_BUILD_TESTS=OFF";

  propagatedUserEnvPkgs = [ qtscriptgenerator ];

  meta = {
    repositories.git = git://anongit.kde.org/amarok.git;
    description = "Popular music player for KDE";
    license = "GPL";
    homepage = http://amarok.kde.org;
    inherit (kdelibs.meta) platforms maintainers;
  };
}
