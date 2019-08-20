{ stdenv, fetchurl
, libusb1, pkgconfig, qmake, qtbase, qttools, qtwebsockets
}:

stdenv.mkDerivation rec {
  name = "moolticute-${version}";
  version = "0.30.8";

  src = fetchurl {
    url = "https://github.com/mooltipass/moolticute/archive/v${version}.tar.gz";
    sha256 = "1qi18r2v0mpw1y007vjgzhiia89fpgsbg2wirxgngl21yxdns1pf";
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
