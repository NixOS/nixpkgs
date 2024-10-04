{
  lib,
  stdenv,
  fetchFromGitLab,
  libdrm,
  json_c,
  pciutils,
  meson,
  ninja,
  pkg-config,
  scdoc,
}:

let
  version = "2.7.0";
in
stdenv.mkDerivation {
  pname = "drm_info";
  inherit version;

  src = fetchFromGitLab {
    owner = "emersion";
    repo = "drm_info";
    domain = "gitlab.freedesktop.org";
    rev = "refs/tags/v${version}";
    hash = "sha256-pgYhZtmyhuhxBiiTRdrEp/YsuwrD6KK/ahfO2L3mfM8=";
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
    scdoc
  ];

  meta = {
    description = "Small utility to dump info about DRM devices";
    mainProgram = "drm_info";
    homepage = "https://gitlab.freedesktop.org/emersion/drm_info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    platforms = lib.platforms.linux;
  };
}
