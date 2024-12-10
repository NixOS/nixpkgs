{
  lib,
  stdenv,
  fetchFromGitHub,
  libdrm,
  json_c,
  pciutils,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "drm_info";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "ascent12";
    repo = "drm_info";
    rev = "v${version}";
    sha256 = "sha256-UTDYLe3QezPCyG9CIp+O+KX716JDTL9mn+OEjjyTwlg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libdrm
    json_c
    pciutils
  ];

  meta = with lib; {
    description = "Small utility to dump info about DRM devices";
    mainProgram = "drm_info";
    homepage = "https://github.com/ascent12/drm_info";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
