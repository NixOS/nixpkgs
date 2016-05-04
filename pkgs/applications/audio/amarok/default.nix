{ stdenv, fetchurl, lib, automoc4, cmake, perl, pkgconfig
, qtscriptgenerator, gettext, curl , libxml2, mysql, taglib
, taglib_extras, loudmouth , kdelibs , qca2, libmtp, liblastfm, libgpod
, phonon , strigi, soprano, qjson, ffmpeg, libofa, nepomuk_core ? null
, lz4, lzo, snappy, libaio, pcre
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "1ilf9wdp3wna5pmvxill8x08rb9gw86qkc2zwm3xk9hpy8l9pf7l";
  };

  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  buildInputs = [
    qtscriptgenerator stdenv.cc.libc gettext curl libxml2 mysql.lib
    taglib taglib_extras loudmouth kdelibs phonon strigi soprano qca2
    libmtp liblastfm libgpod qjson ffmpeg libofa nepomuk_core
    lz4 lzo snappy libaio pcre
  ];

  # This is already fixed upstream, will be release in 2.9
  preConfigure = ''
    sed -i -e 's/STRLESS/VERSION_LESS/g' cmake/modules/FindTaglib.cmake
  '';

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
