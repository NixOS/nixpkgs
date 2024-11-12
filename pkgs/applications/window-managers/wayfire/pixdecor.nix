{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  meson,
  ninja,
  pkg-config,
  wayfire,
  libinput,
  libxkbcommon,
  libGL,
  xcbutilwm,
  nlohmann_json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixdecor";
  version = "0-unstable-2024-08-17";

  src = fetchFromGitHub {
    owner = "soreau";
    repo = "pixdecor";
    rev = "18779dd970c703d3437173ee7f640aa210ec69ea";
    hash = "sha256-3xdrGtEKFli/k1M5E4+0VJHs/eKhgw/50Y6YGWji6os=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  dontWrapGApps = true;

  buildInputs = [
    libGL
    libinput
    libxkbcommon
    nlohmann_json
    wayfire
    xcbutilwm
  ];

  postPatch = ''
    substituteInPlace metadata/meson.build \
      --replace "wayfire.get_variable( pkgconfig: 'metadatadir' )" "join_paths(get_option('prefix'), 'share/wayfire/metadata')"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/soreau/pixdecor";
    description = "A highly configurable decorator plugin for wayfire,";
    longDescription = "pixdecor features antialiased rounded corners with shadows and optional animated effects.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x5a4 ];
    inherit (wayfire.meta) platforms;
  };
})
