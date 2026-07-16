{
  lib,
  stdenv,
  fetchFromGitLab,
  libdrm,
  libdisplay-info,
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
  version = "2.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "drm_info";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QKF0frDPelwHOzf3r0tzSo7i1WfGhcFGJfxf2bj1+OE=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "'<2.4.134'" "'<2.4.133'"
  '';

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
    libdisplay-info
    json_c
    pciutils
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small utility to dump info about DRM devices";
    mainProgram = "drm_info";
    homepage = "https://gitlab.freedesktop.org/emersion/drm_info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiskae ];
    platforms = lib.platforms.linux;
  };
})
