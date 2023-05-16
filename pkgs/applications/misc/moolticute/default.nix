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
<<<<<<< HEAD
  version = "1.02.0";
=======
  version = "1.01.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mooltipass";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-URGAhd7u1DrGReQAwsX9LMj7Jq1GsILzP8fVFnA74O4=";
=======
    sha256 = "sha256-6vqYyAJ9p0ey49kc2Tp/HZVv0mePARX2dcmcIG4bcNQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "udev" ];

  nativeBuildInputs = [ pkg-config qmake qttools ];
  buildInputs = [ libusb1 qtbase qtwebsockets ];

  preConfigure = "mkdir -p build && cd build";
  qmakeFlags = [ "../Moolticute.pro" ];

  preInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    sed -n '/^UDEV_RULE=="\$(cat <<-EOF$/,/^EOF$/p' ../data/moolticute.sh |
        sed '1d;$d' > $udev/lib/udev/rules.d/50-mooltipass.rules
 '';

  meta = with lib; {
    description = "GUI app and daemon to work with Mooltipass device via USB";
    longDescription = ''
      To install udev rules, add `services.udev.packages = [ pkgs.moolticute.udev ]`
      into `nixos/configuration.nix`.
    '';
    homepage = "https://github.com/mooltipass/moolticute";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kirikaza hughobrien ];
    platforms = platforms.linux;
  };
}
