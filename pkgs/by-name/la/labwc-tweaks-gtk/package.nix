{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  libxml2,
  xkeyboard_config,
  wrapGAppsHook3,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks-gtk";
<<<<<<< HEAD
  version = "0-unstable-2025-12-16";
=======
  version = "0-unstable-2025-06-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks-gtk";
<<<<<<< HEAD
    rev = "553788d5be02e3dd5f0f0ba4191878d94f60f07f";
    hash = "sha256-dEdMbeGNeT7wzq+LhUnBLUlWGqXf55rwrs/58axyO+o=";
=======
    rev = "394a61ed5a546c59d4e632a5a7b184aecc79166a";
    hash = "sha256-/iYe3FVIFo74XnyWeUHpWjmLCw8MsZBqXp55o0FjILA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace stack-lang.c --replace /usr/share/X11/xkb ${xkeyboard_config}/share/X11/xkb
    substituteInPlace theme.c --replace /usr/share /run/current-system/sw/share
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-tweaks-gtk";
    description = "Configuration gui app for labwc; gtk fork";
    mainProgram = "labwc-tweaks-gtk";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
