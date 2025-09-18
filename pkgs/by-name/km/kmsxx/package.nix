{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  pkg-config,
  libdrm,
  fmt,
  libevdev,
  withPython ? false,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2021-07-26";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "54f591ec0de61dd192baf781c9b2ec87d5b461f7";
    hash = "sha256-j+20WY4a2iTKZnYjXhxbNnZZ53K3dHpDMTp+ZulS+7c=";
  };

  # Didn't detect pybind11 without cmake
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals withPython [ cmake ];
  buildInputs = [
    libdrm
    fmt
    libevdev
  ]
  ++ lib.optionals withPython (
    with python3Packages;
    [
      python
      pybind11
    ]
  );

  dontUseCmakeConfigure = true;

  mesonFlags = lib.optional (!withPython) "-Dpykms=disabled";

  meta = with lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = "https://github.com/tomba/kmsxx";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
