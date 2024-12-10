{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  alsa-lib,
  boost,
  chromaprint,
  fftw,
  gnutls,
  libcdio,
  libebur128,
  libmtp,
  libpthreadstubs,
  libtasn1,
  libXdmcp,
  ninja,
  pcre,
  protobuf,
  sqlite,
  taglib,
  libgpod,
  libidn2,
  libpulseaudio,
  libselinux,
  libsepol,
  p11-kit,
  util-linux,
  qtbase,
  qtx11extras ? null, # doesn't exist in qt6
  qttools,
  withGstreamer ? true,
  glib-networking,
  gst_all_1,
  withVlc ? true,
  libvlc,
  nix-update-script,
}:

let
  inherit (lib) optionals optionalString;

in
stdenv.mkDerivation rec {
  pname = "strawberry";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "jonaski";
    repo = pname;
    rev = version;
    hash = "sha256-hzZx530HD7R3JOG6cCsoaW9puYkmu7m5lr+EfobKX7o=";
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
      libcdio
      libebur128
      libidn2
      libmtp
      libpthreadstubs
      libtasn1
      libXdmcp
      pcre
      protobuf
      sqlite
      taglib
      qtbase
      qtx11extras
    ]
    ++ optionals stdenv.isLinux [
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
        gstreamer
        gst-libav
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
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
    ++ optionals stdenv.isLinux [
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
