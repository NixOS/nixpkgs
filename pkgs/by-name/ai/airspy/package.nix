{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "airspy";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "airspy";
    repo = "airspyone_host";
    rev = "v${version}";
    sha256 = "1v7sfkkxc6f8ny1p9xrax1agkl6q583mjx8k0lrrwdz31rf9qgw9";
  };

  postPatch = ''
    substituteInPlace airspy-tools/CMakeLists.txt --replace "/etc/udev/rules.d" "$out/etc/udev/rules.d"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [ "-DINSTALL_UDEV_RULES=ON" ];

  meta = {
    homepage = "https://github.com/airspy/airspyone_host";
    description = "Host tools and driver library for the AirSpy SDR";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
