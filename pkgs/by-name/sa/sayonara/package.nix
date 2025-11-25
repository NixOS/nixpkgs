{
  stdenv,
  cmake,
  fetchFromGitLab,
  nix-update-script,
  gst_all_1,
  lib,
  libpulseaudio,
  ninja,
  pcre,
  pkg-config,
  taglib,
  zlib,
  python3,
  libsForQt5,
}:

let
  py = python3.withPackages (
    ps: with ps; [
      pydbus
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sayonara";
  version = "1.10.0-stable1";

  src = fetchFromGitLab {
    owner = "luciocarreras";
    repo = "sayonara-player";
    tag = finalAttrs.version;
    hash = "sha256-ZcuWe1dsLJS4/nLXSSKB7wzPU9COFyE4vPSwZIo0bgI=";
  };

  # error: no matching function for call to 'max'
  postPatch = ''
    substituteInPlace src/Components/Playlist/PlaylistModifiers.cpp \
      --replace-fail "std::max" "std::max<MilliSeconds>"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libpulseaudio
    pcre
    libsForQt5.qtbase
    taglib
    zlib
    py
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  # we carry the patched taglib 1.11.1 that doesn't break ogg but sayonara just
  # checks for the version
  cmakeFlags = [
    "-DWITH_SYSTEM_TAGLIB=ON"
  ];

  # gstreamer cannot otherwise be found
  env.NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Sayonara music player";
    homepage = "https://sayonara-player.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ deepfire ];
    platforms = lib.platforms.unix;
  };
})
