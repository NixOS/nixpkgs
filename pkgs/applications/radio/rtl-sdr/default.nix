{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "librtlsdr";
    repo = "librtlsdr";
    rev = "v${version}";
    hash = "sha256-s03h+3EfC5c7yRYBM6aCRWtmstwRJWuBywuyVt+k/bk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
<<<<<<< HEAD
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
      --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch version}"
=======
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  propagatedBuildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  meta = with lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = "https://github.com/librtlsdr/librtlsdr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
