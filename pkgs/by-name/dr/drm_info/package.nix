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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drm_info";
  version = "2.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "drm_info";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pgYhZtmyhuhxBiiTRdrEp/YsuwrD6KK/ahfO2L3mfM8=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libdrm
    json_c
    pciutils
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Small utility to dump info about DRM devices";
    mainProgram = "drm_info";
    homepage = "https://gitlab.freedesktop.org/emersion/drm_info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiskae ];
    platforms = platforms.linux;
  };
})
