{ stdenv, fetchurl, SDL, frei0r, gettext, makeWrapper, mlt, pkgconfig, qtbase, qmakeHook }:

stdenv.mkDerivation rec {
  name = "shotcut-${version}";
  version = "14.09";

  src = fetchurl {
    url = "https://github.com/mltframework/shotcut/archive/v${version}.tar.gz";
    sha256 = "1504ds3ppqmpg84nb2gb74qndqysjwn3xw7n8xv19kd1pppnr10f";
  };

  buildInputs = [ SDL frei0r gettext makeWrapper mlt pkgconfig qtbase qmakeHook ];

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
    wrapProgram $out/bin/shotcut --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
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
    broken = true;
  };
}
