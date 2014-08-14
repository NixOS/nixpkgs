{ stdenv, fetchurl, SDL, frei0r, gettext, makeWrapper, mlt, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "shotcut-${version}";
  version = "14.08";

  src = fetchurl {
    url = "https://github.com/mltframework/shotcut/archive/v${version}.tar.gz";
    sha256 = "0klcvpgp2l6xcdjy1gg7a5s8mx0mm347zdf26q6kk685pldlvkyj";
  };

  buildInputs = [ SDL frei0r gettext makeWrapper mlt pkgconfig qt5 ];

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
