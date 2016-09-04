{ stdenv, fetchurl, SDL, frei0r, gettext, mlt, jack1, pkgconfig, qtbase,
qtmultimedia, qtwebkit, qtx11extras, qtwebsockets, qtquickcontrols,
qtgraphicaleffects,
qmakeHook, makeQtWrapper }:

stdenv.mkDerivation rec {
  name = "shotcut-${version}";
  version = "16.08";

  src = fetchurl {
    url = "https://github.com/mltframework/shotcut/archive/v${version}.tar.gz";
    sha256 = "10f32mfj3f8mjp0yi0jb7wc5d3inycn5c1pvqdagjhyyv3rvx9zy";
  };

  buildInputs = [ SDL frei0r gettext mlt pkgconfig qtbase qtmultimedia qtwebkit
    qtx11extras qtwebsockets qtquickcontrols qtgraphicaleffects qmakeHook makeQtWrapper ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
    wrapQtProgram $out/bin/shotcut --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1 --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ jack1 SDL ]}
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
    homepage = http://shotcut.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;

    # after qt5 bump it probably needs to be updated,
    # but newer versions seem to need newer than the latest stable mlt
    # broken = true;
  };
}
