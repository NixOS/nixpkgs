{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
    tag = "v${version}";
    sha256 = "1v7sfkkxc6f8ny1p9xrax1agkl6q583mjx8k0lrrwdz31rf9qgw9";
  };

  patches = [
    # CMake < 3.5 fix. Remove upon next version bump.
    (fetchpatch {
      url = "https://github.com/airspy/airspyone_host/commit/7290309a663ced66e1e51dc65c1604e563752310.patch";
      hash = "sha256-DZ7hYFBu9O2e6Fdx3yJdoCHoE1uVhzih0+OpiPTvkaI=";
    })
    (fetchpatch {
      url = "https://github.com/airspy/airspyone_host/commit/3cf6f97976611c2ff6363f7927fe76c465995801.patch";
      hash = "sha256-7LU3UvpvwQdDF8GPZw/W4Z2CSzUCNk47McNHti3YHP8=";
    })
    (fetchpatch {
      url = "https://github.com/airspy/airspyone_host/commit/f467acd587617640741ecbfade819d10ecd032c2.patch";
      hash = "sha256-qfJrxM1hq7NScxN++d9IH+fwFfXf/YwZZUDDOVbwIJk=";
    })
  ];

  postPatch = ''
    substituteInPlace airspy-tools/CMakeLists.txt --replace "/etc/udev/rules.d" "$out/etc/udev/rules.d"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doInstallCheck = true;
  buildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    homepage = "https://github.com/airspy/airspyone_host";
    description = "Host tools and driver library for the AirSpy SDR";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ markuskowa ];
  };
}
