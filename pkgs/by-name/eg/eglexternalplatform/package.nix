{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "eglexternalplatform";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "eglexternalplatform";
    rev = version;
    hash = "sha256-t0dka5aUv5hB4G8PbSGiIY74XIFAsmo5a7dfWb2QCLM=";
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
