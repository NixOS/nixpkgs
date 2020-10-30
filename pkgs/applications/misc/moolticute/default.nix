{ lib, mkDerivation, fetchFromGitHub
, libusb1
, pkg-config
, qmake
, qtbase
, qttools
, qtwebsockets
}:

mkDerivation rec {
  pname = "moolticute";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "mooltipass";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xlbhx6f1ysx8gka8g67271whzhkzsnkavpq3x58hdxr8v88khby";
  };

  outputs = [ "out" "udev" ];

  nativeBuildInputs = [ pkg-config qmake qttools ];
  buildInputs = [ libusb1 qtbase qtwebsockets ];

  preConfigure = "mkdir -p build && cd build";
  qmakeFlags = [ "../Moolticute.pro" ];

  preInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    sed -n '/^ \+cat > "$tmpfile" <<- EOF$/,/^EOF$/p' ../data/moolticute.sh |
        sed '1d;$d' > $udev/lib/udev/rules.d/50-mooltipass.rules
 '';

  meta = with lib; {
    description = "GUI app and daemon to work with Mooltipass device via USB";
    longDescription = ''
      To install udev rules, add `services.udev.packages == [ moolticute.udev ]`
      into `nixos/configuration.nix`.
    '';
    homepage = "https://github.com/mooltipass/moolticute";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.kirikaza ];
    platforms = platforms.linux;
  };
}
