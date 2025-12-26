{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "eglexternalplatform";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "eglexternalplatform";
    rev = version;
    hash = "sha256-tDKh1oSnOSG/XztHHYCwg1tDB7M6olOtJ8te+uan9ko=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "EGL External Platform interface";
    homepage = "https://github.com/NVIDIA/eglexternalplatform";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hedning ];
  };
}
