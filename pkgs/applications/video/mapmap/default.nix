{ stdenv 
, fetchFromGitHub
, qttools
, qtmultimedia
, liblo
, gst_all_1
, qmake
, pkgconfig
}:

with stdenv;

mkDerivation rec {

  version = "0.6.1";
  name = "mapmap-${version}";

  src = fetchFromGitHub {
    owner = "mapmapteam";
    repo = "mapmap";
    rev = version;
    sha256 = "15km6xmfkxhrflq4sl9m9r85zi4shrr4k5h15x17v7x0qkc3xgsh";
  };

  nativeBuildInputs = [
    qmake
    pkgconfig
  ];

  buildInputs = [
    qttools
    qtmultimedia
    liblo
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp mapmap $out/bin/mapmap
    mkdir -p $out/share/applications/
    sed 's|Icon=/usr/share/icons/hicolor/scalable/apps/mapmap.svg|Icon=mapmap|g' resources/texts/mapmap.desktop > $out/share/applications/mapmap.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp resources/images/logo/mapmap.* $out/share/icons/hicolor/scalable/apps/
  '';

  # RPATH in /tmp hack
  # preFixup = ''
  #   rm -r $NIX_BUILD_TOP/__nix_qt5__
  # '';

  meta = with stdenv.lib; {
    description = "Open source video mapping software";
    homepage = https://github.com/mapmapteam/mapmap;
    license = licenses.gpl3;
    maintainers = [ maintainers.erictapen ];
    platforms = platforms.linux;
  };

}
