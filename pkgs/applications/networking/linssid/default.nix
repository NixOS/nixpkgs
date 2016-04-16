{ stdenv, fetchurl, qtbase, qtsvg, qmakeHook, pkgconfig, boost, wirelesstools, iw, qwt6 }:

stdenv.mkDerivation rec {
  name = "linssid-${version}";
  version = "2.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/linssid/LinSSID_${version}/linssid_${version}.orig.tar.gz";
    sha256 = "13d35rlcjncd8lx3khkgn9x8is2xjd5fp6ns5xsn3w6l4xj9b4gl";
  };

  buildInputs = [ qtbase qtsvg pkgconfig boost qwt6 qmakeHook ];

  patches = [ ./0001-unbundled-qwt.patch ];

  postPatch = ''
    sed -e "s|/usr/include/|/nonexistent/|g" -i linssid-app/*.pro
    sed -e 's|^LIBS .*= .*libboost_regex.a|LIBS += -lboost_regex|' \
        -e "s|/usr|$out|g" \
        -i linssid-app/linssid-app.pro linssid-app/linssid.desktop
    sed -e "s|\.\./\.\./\.\./\.\./usr|$out|g" -i linssid-app/*.ui

    sed -e "s|iwlist|${wirelesstools}/sbin/iwlist|g" -i linssid-app/Getter.cpp
    sed -e "s|iw dev|${iw}/sbin/iw dev|g" -i linssid-app/MainForm.cpp

    # Remove bundled qwt
    rm -fr qwt-lib
  '';

  meta = with stdenv.lib; {
    description = "Graphical wireless scanning for Linux";
    homepage = http://sourceforge.net/projects/linssid/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
