{
  alsa-lib,
  boost,
  chromaprint,
  cmake,
  fetchFromGitHub,
  fftw,
  glib-networking,
  gnutls,
  gst_all_1,
  lib,
  libXdmcp,
  libcdio,
  libebur128,
  libgpod,
  libidn2,
  libmtp,
  libpthreadstubs,
  libpulseaudio,
  libselinux,
  libsepol,
  libtasn1,
  libvlc,
  ninja,
  nix-update-script,
  p11-kit,
  pcre,
  pkg-config,
  protobuf,
  qtbase,
  qttools,
  qtx11extras ? null, # doesn't exist in qt6
  sqlite,
  stdenv,
  taglib,
  util-linux,
  withGstreamer ? true,
  withVlc ? true,
  wrapQtAppsHook,
}:

let
  inherit (lib) optionals optionalString;

in
stdenv.mkDerivation rec {
  pname = "strawberry";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = pname;
    rev = version;
    hash = "sha256-yca1BJWhSUVamqSKfvEzU3xbzdR+kwfSs0pyS08oUR0=";
    fetchSubmodules = true;
  };

  # the big strawberry shown in the context menu is *very* much in your face, so use the grey version instead
  postPatch = ''
    substituteInPlace src/context/contextalbum.cpp \
      --replace pictures/strawberry.png pictures/strawberry-grey.png
  '';

  buildInputs =
    [
      alsa-lib
      boost
      chromaprint
      fftw
      gnutls
      libXdmcp
      libcdio
      libebur128
      libidn2
      libmtp
      libpthreadstubs
      libtasn1
      pcre
      protobuf
      qtbase
      qtx11extras
      sqlite
      taglib
    ]
    ++ optionals stdenv.hostPlatform.isLinux [
      libgpod
      libpulseaudio
      libselinux
      libsepol
      p11-kit
    ]
    ++ optionals withGstreamer (
      with gst_all_1;
      [
        glib-networking
        gst-libav
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
        gstreamer
      ]
    )
    ++ optionals withVlc [ libvlc ];

  nativeBuildInputs =
    [
      cmake
      ninja
      pkg-config
      qttools
      wrapQtAppsHook
    ]
    ++ optionals stdenv.hostPlatform.isLinux [
      util-linux
    ];

  postInstall = optionalString withGstreamer ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Music player and music collection organizer";
    homepage = "https://www.strawberrymusicplayer.org/";
    changelog = "https://raw.githubusercontent.com/jonaski/strawberry/${version}/Changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    # upstream says darwin should work but they lack maintainers as of 0.6.6
    platforms = platforms.linux;
    mainProgram = "strawberry";
  };
}
