{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, qttools
, qtmultimedia
, liblo
, gst_all_1
, qmake
, pkg-config
, wrapQtAppsHook
}:

with stdenv;

mkDerivation rec {

  version = "0.6.2";
  pname = "mapmap";

  src = fetchFromGitHub {
    owner = "mapmapteam";
    repo = "mapmap";
    rev = version;
    sha256 = "1pyb3vz19lbfz2hrfqm9a29vnajw1bigdrblbmcy32imkf4isfvm";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
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

  patches = [
    (fetchpatch {
      name = "message-handler-segfault.patch";
      url = "https://github.com/mapmapteam/mapmap/pull/519/commits/22eeee59ba7de6de7b73ecec3b0ea93bdc7f04e8.patch";
      sha256 = "0is905a4lf9vvl5b1n4ky6shrnbs5kz9mlwfk78hrl4zabfmcl5l";
    })
    # fix build with libsForQt515
    (fetchpatch {
      url = "https://github.com/mapmapteam/mapmap/pull/518/commits/ac49acc1e2ec839832b86838e93a8c13030affeb.patch";
      sha256 = "sha256-tSLbyIDv5mSejnw9oru5KLAyQqjgJLLREKQomEUcGt8=";
    })
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

  meta = with lib; {
    description = "Open source video mapping software";
    homepage = "https://github.com/mapmapteam/mapmap";
    license = licenses.gpl3;
    maintainers = [ maintainers.erictapen ];
    platforms = platforms.linux;
    mainProgram = "mapmap";
  };

}
