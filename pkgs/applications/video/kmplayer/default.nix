{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules, makeWrapper,
  libpthreadstubs, libXdmcp,
  qtsvg, qtx11extras, ki18n, kdelibs4support, kio, kmediaplayer, kwidgetsaddons,
  phonon, cairo, mplayer
}:

mkDerivation rec {
  majorMinorVersion = "0.12";
  patchVersion = "0b";
  version = "${majorMinorVersion}.${patchVersion}";
  pname = "kmplayer";

  src = fetchurl {
    url = "mirror://kde/stable/kmplayer/${majorMinorVersion}/kmplayer-${version}.tar.bz2";
    sha256 = "0wzdxym4fc83wvqyhcwid65yv59a2wvp1lq303cn124mpnlwx62y";
  };

  patches = [
    ./kmplayer_part-plugin_metadata.patch # Qt 5.9 doesn't like an empty string for the optional "FILE" argument of "Q_PLUGIN_METADATA"
    ./no-docs.patch # Don't build docs due to errors (kdelibs4support propagates kdoctools)
  ];

  postPatch = ''
    sed -i src/kmplayer.desktop \
      -e "s,^Exec.*,Exec=$out/bin/kmplayer -qwindowtitle %c %i %U,"
  '';

  # required for kf5auth to work correctly
  cmakeFlags = ["-DCMAKE_POLICY_DEFAULT_CMP0012=NEW"];

  nativeBuildInputs = [ extra-cmake-modules makeWrapper ];

  buildInputs = [
    libpthreadstubs libXdmcp
    qtsvg qtx11extras ki18n kdelibs4support kio kmediaplayer kwidgetsaddons
    phonon cairo
  ];

  postInstall = ''
    wrapProgram $out/bin/kmplayer --suffix PATH : ${mplayer}/bin
  '';

  meta = with lib; {
    description = "MPlayer front-end for KDE";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl12Plus ];
    homepage = "https://kmplayer.kde.org/";
    maintainers = with maintainers; [ sander zraexy ];
  };
}
