{ stdenv, fetchurl, SDL, frei0r, gettext, makeWrapper, mlt, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "shotcut-${version}";
  version = "14.07";

  src = fetchurl {
    url = "https://github.com/mltframework/shotcut/archive/v${version}.tar.gz";
    sha256 = "05g0b3jhmmdv8qnlgmi8wsfi7l3c5zvjcrrb3q7ajfc3q7yf6k6a";
  };

  buildInputs = [ SDL frei0r gettext makeWrapper mlt pkgconfig qt5 ];

  # Fixed in git and can be removed for the next release
  patches = [ ./CuteLogger.patch ];

  configurePhase = "qmake PREFIX=$out";

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
    wrapProgram $out/bin/shotcut --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, cross-platform video editor";
    longDescription = ''
      An offical binary for Shotcut, which includes all the
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
  };
}
