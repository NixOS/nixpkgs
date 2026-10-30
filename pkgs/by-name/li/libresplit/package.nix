{
  lib,
  stdenv,
  fetchFromGitHub,
  glib-networking,
  gtk4,
  gvfs,
  jansson,
  lua5_4,
  meson,
  ninja,
  openssl,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libresplit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OgEWqVD/uXIKIM/OH63EyWIn1lJvPhr2xEgJNOBvGRc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    jansson
    lua5_4
    openssl
    # Optional deps for web split icons
    glib-networking
    gvfs
  ];

  # False positive:
  #     char dot_subsecs[8];
  #     sprintf(dot_subsecs, ".%06lld", time % 1000000LL);
  # GCC thinks it might be 9 bytes because it doesn't detect
  # the negative time check just above.
  hardeningDisable = [ "strictoverflow" ];

  meta = {
    homepage = "https://github.com/LibreSplitDev/LibreSplit";
    description = "Speedrun timer with auto splitting and load removal for Linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "libresplit";
    platforms = lib.platforms.linux;
  };
})
