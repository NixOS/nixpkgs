{ stdenv, fetchurl
, libusb1, pkgconfig, qmake, qtbase, qttools, qtwebsockets
}:

stdenv.mkDerivation rec {
  pname = "moolticute";
  version = "0.42.1";

  src = fetchurl {
    url = "https://github.com/mooltipass/moolticute/archive/v${version}.tar.gz";
    sha256 = "1qx8hz1ikblhryvm33bbbqaz17jhykrirjrs9lhps7s2lpkwsrbw";
  };

  preConfigure = "mkdir -p build && cd build";
  nativeBuildInputs = [ pkgconfig qmake qttools ];
  qmakeFlags = [ "../Moolticute.pro" ];

  outputs = [ "out" "udev" ];
  preInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    sed -n '/^ \+cat > "$tmpfile" <<- EOF$/,/^EOF$/p' ../data/moolticute.sh |
        sed '1d;$d' > $udev/lib/udev/rules.d/50-mooltipass.rules
 '';
  
  buildInputs = [ libusb1 qtbase qtwebsockets ];

  meta = with stdenv.lib; {
    description = "GUI app and daemon to work with Mooltipass device via USB";
    longDescription = ''
      To install udev rules, add `services.udev.packages == [ moolticute.udev ]`
      into `nixos/configuration.nix`.
    '';
    homepage = https://github.com/mooltipass/moolticute;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.kirikaza ];
    platforms = platforms.linux;
  };
}
