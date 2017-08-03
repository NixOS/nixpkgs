{ stdenv, fetchurl, SDL, frei0r, gettext, mlt, jack1, pkgconfig, qtbase,
qtmultimedia, qtwebkit, qtx11extras, qtwebsockets, qtquickcontrols,
qtgraphicaleffects,
qmake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "shotcut-${version}";
  version = "17.02";

  src = fetchurl {
    url = "https://github.com/mltframework/shotcut/archive/v${version}.tar.gz";
    sha256 = "09nygz1x9fvqf33gqpc6jnr1j7ny0yny3w2ngwqqfkf3f8n83qhr";
  };


  enableParallelBuilding = true;
  nativeBuildInputs = [ makeWrapper pkgconfig qmake ];
  buildInputs = [
    SDL frei0r gettext mlt
    qtbase qtmultimedia qtwebkit qtx11extras qtwebsockets qtquickcontrols
    qtgraphicaleffects
  ];

  prePatch = ''
    sed 's_shotcutPath, "qmelt"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp
    sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
    NICE=$(type -P nice)
    sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
  '';

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
    wrapProgram $out/bin/shotcut --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1 --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ jack1 SDL ]} --prefix PATH : ${mlt}/bin
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = https://shotcut.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;

    # after qt5 bump it probably needs to be updated,
    # but newer versions seem to need newer than the latest stable mlt
    # broken = true;
  };
}
