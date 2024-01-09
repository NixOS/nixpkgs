{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk3
, libxml2
, xkeyboard_config
, wrapGAppsHook
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks";
  version = "unstable-2023-12-08";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = finalAttrs.pname;
    rev = "1c79d6a5ee3ac3d1a6140a1a98ae89674ef36635";
    hash = "sha256-RD1VCKVoHsoY7SezY7tjZzomikMgA7N6B5vaYkIo9Es=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace stack-lang.c --replace /usr/share/X11/xkb ${xkeyboard_config}/share/X11/xkb
    sed -i '/{ NULL, "\/usr\/share" },/i { NULL, "/run/current-system/sw/share" },' theme.c
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-tweaks";
    description = "Configuration gui app for labwc";
    mainProgram = "labwc-tweaks";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
