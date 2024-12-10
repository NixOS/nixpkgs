{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wayfire,
  eudev,
  libinput,
  libxkbcommon,
  librsvg,
  libGL,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windecor";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = "wayfireplugins";
    repo = "windecor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v0kGT+KrtfFJ/hp1Dr8izKVj6UHhuW6udHFjWt1y9TY=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "wayfire.get_variable( pkgconfig: 'metadatadir' )" "join_paths(get_option('prefix'), 'share/wayfire/metadata')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    eudev
    libinput
    libxkbcommon
    librsvg
    libGL
    xcbutilwm
  ];

  mesonFlags = [ "--sysconfdir=/etc" ];

  meta = {
    homepage = "https://gitlab.com/wayfireplugins/windecor";
    description = "A window decoration plugin for wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
