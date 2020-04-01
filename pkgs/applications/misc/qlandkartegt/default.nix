{ mkDerivation, lib, fetchurl, fetchpatch, cmake
, qtmultimedia, qtserialport, qtscript, qtwebkit
, garmindev, gdal, gpsd, libdmtx, libexif, libGLU, proj }:

mkDerivation rec {
  pname = "qlandkartegt";
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1rwv5ar5jv15g1cc6pp0lk69q3ip10pjazsh3ds2ggaciymha1ly";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-gps_read.patch?h=qlandkartegt";
      sha256 = "1xyqxdqxwviq7b8jjxssxjlkldk01ms8dzqdjgvjs8n3fh7w0l70";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-incomplete-type.patch?h=qlandkartegt";
      sha256 = "1q7rm321az3q6pq5mq0yjrihxl9sf3nln9z3xp20g9qldslv2cy2";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-proj_api.patch?h=qlandkartegt";
      sha256 = "12yibxn85z2n30azmhyv02q091jj5r50nlnjq4gfzyqd3xb9582n";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-qt5-build.patch?h=qlandkartegt";
      sha256 = "1wq2hr06gzq8m7zddh10vizmvpwp4lcy1g86rlpppvdc5cm3jpkl";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-qtgui-include.patch?h=qlandkartegt";
      sha256 = "16hql8ignzw4n1hlp4icbvaddqcadh2rjns0bvis720535112sc8";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-ver_str.patch?h=qlandkartegt";
      sha256 = "13fg05gqrjfa9j00lrqz1b06xf6r5j01kl6l06vkn0hz1jzxss5m";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/improve-gpx-creator.patch?h=qlandkartegt";
      sha256 = "1sdf5z8qrd43azrhwfw06zc0qr48z925hgbcfqlp0xrsxv2n6kks";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/improve-gpx-name.patch?h=qlandkartegt";
      sha256 = "10phafhns79i3rl4zpc7arw11x46cywgkdkxm7gw1i9y5h0cal79";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qtmultimedia qtserialport qtscript qtwebkit
    garmindev gdal gpsd libdmtx libexif libGLU proj
  ];

  cmakeFlags = [
    "-DQK_QT5_PORT=ON"
    "-DEXIF_LIBRARIES=${libexif}/lib/libexif.so"
    "-DEXIF_INCLUDE_DIRS=${libexif}/include"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace ConfigureChecks.cmake \
      --replace \$\{PLUGIN_INSTALL_DIR\} "${garmindev}/lib/qlandkartegt"
  '';

  postInstall = ''
    mkdir -p $out/share/mime/packages
    cat << EOF > $out/share/mime/packages/qlandkartegt.xml
    <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
      <mime-type type="application/vnd.qlandkartegt.qlb">
        <comment>QLandkarteGT File</comment>
        <glob pattern="*.qlb"/>
      </mime-type>
    </mime-info>
    EOF
  '';

  meta = with lib; {
    homepage = http://www.qlandkarte.org/;
    description = ''
      QLandkarte GT is the ultimate outdoor aficionado's tool.
      It supports GPS maps in GeoTiff format as well as Garmin's img vector map format.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux;
  };
}
