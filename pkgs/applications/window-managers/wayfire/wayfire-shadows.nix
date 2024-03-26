{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, meson
, ninja
, pkg-config
, wayfire
, libxkbcommon
, libGL
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-shadows";
  version = "unstable-2023-09-09";

  src = fetchFromGitHub {
    owner = "timgott";
    repo = "wayfire-shadows";
    rev = "de3239501fcafd1aa8bd01d703aa9469900004c5";
    hash = "sha256-oVlSzpddPDk6pbyLFMhAkuRffkYpinP7jRspVmfLfyA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    libxkbcommon
    libGL
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/timgott/wayfire-shadows";
    description = "Wayfire plugin that adds window shadows";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
