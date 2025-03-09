{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  pico-sdk,
  mbedtls_2,
}:

stdenv.mkDerivation rec {
  pname = "picotool";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "sha256-z7EFk3qxg1PoKZQpUQqjhttZ2RkhhhiMdYc9TkXzkwk=";
  };

  postPatch = ''
    # necessary for signing/hashing support. our pico-sdk does not come with
    # it by default, and it shouldn't due to submodule size. pico-sdk uses
    # an upstream version of mbedtls 2.x so we patch ours in directly.
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail "''$"'{PICO_SDK_PATH}/lib/mbedtls' '${mbedtls_2.src}'
  '';

  buildInputs = [
    libusb1
    pico-sdk
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  cmakeFlags = [ "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk" ];

  postInstall = ''
    install -Dm444 ../udev/99-picotool.rules -t $out/etc/udev/rules.d
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/picotool";
    description = "Tool for interacting with RP2040/RP2350 device(s) in BOOTSEL mode, or with an RP2040/RP2350 binary";
    mainProgram = "picotool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
