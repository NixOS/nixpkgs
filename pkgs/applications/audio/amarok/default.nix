{ stdenv, fetchurl, lib, qtscriptgenerator, perl, gettext, curl
, libxml2, mysql, taglib, taglib_extras, loudmouth , kdelibs
, qca2, libmtp, liblastfm, libgpod, pkgconfig, automoc4, phonon
, strigi, soprano, qjson, ffmpeg, libofa }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "amarok";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "12dvqnx6jniykbi6sz94xxlnxzafjsaxlf0mppk9w5wn61jwc3cy";
  };

  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";
  patches = ./find-mysql.patch;
  buildInputs = [ qtscriptgenerator stdenv.gcc.libc gettext curl
    libxml2 mysql taglib taglib_extras loudmouth kdelibs automoc4 phonon strigi
    soprano qca2 libmtp liblastfm libgpod pkgconfig qjson ffmpeg libofa ];

  cmakeFlags = "-DKDE4_BUILD_TESTS=OFF";

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
