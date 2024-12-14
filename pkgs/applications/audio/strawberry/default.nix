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
  kdsingleapplication,
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
  ninja,
  nix-update-script,
  p11-kit,
  pkg-config,
  qtbase,
  qttools,
  sqlite,
  stdenv,
  taglib,
  util-linux,
  wrapQtAppsHook,
}:

let
  inherit (lib) optionals;

in
stdenv.mkDerivation rec {
  pname = "strawberry";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = pname;
    rev = version;
    hash = "sha256-90gnPw21oBHrRslJmB2hUId0WI7Gf+I4bvdS+dvAHdI=";
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
      kdsingleapplication
      libXdmcp
      libcdio
      libebur128
      libidn2
      libmtp
      libpthreadstubs
      libtasn1
      qtbase
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
    ++ (with gst_all_1; [
      glib-networking
      gst-libav
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer
    ]);

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

  postInstall = ''
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
