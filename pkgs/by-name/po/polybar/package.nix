{
  config,
  cairo,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libuv,
  libxdmcp,
  libpthread-stubs,
  libxcb,
  pcre,
  pkg-config,
  python3,
  python3Packages, # sphinx-build
  lib,
  stdenv,
  xcbproto,
  libxcb-util,
  libxcb-cursor,
  libxcb-image,
  libxcb-render-util,
  libxcb-wm,
  xcbutilxrm,
  makeWrapper,
  removeReferencesTo,
  alsa-lib,
  curl,
  libmpdclient,
  libpulseaudio,
  wirelesstools,
  libnl,
  i3,
  jsoncpp,

  # override the variables ending in 'Support' to enable or disable modules
  alsaSupport ? true,
  githubSupport ? false,
  mpdSupport ? false,
  pulseSupport ? config.pulseaudio or false,
  iwSupport ? false,
  nlSupport ? true,
  i3Support ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polybar";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "polybar";
    repo = "polybar";
    tag = finalAttrs.version;
    hash = "sha256-5PYKl6Hi4EYEmUBwkV0rLiwxNqIyR5jwm495YnNs0gI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.sphinx
    removeReferencesTo
  ]
  ++ lib.optional i3Support makeWrapper;

  buildInputs = [
    cairo
    libuv
    libxdmcp
    libpthread-stubs
    libxcb
    pcre
    python3
    xcbproto
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-render-util
    libxcb-wm
    xcbutilxrm
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional githubSupport curl
  ++ lib.optional mpdSupport libmpdclient
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional iwSupport wirelesstools
  ++ lib.optional nlSupport libnl
  ++ lib.optionals i3Support [
    jsoncpp
    i3
  ];

  patches = [
    # FIXME: remove after version update
    (fetchpatch {
      name = "gcc15-cstdint-fix.patch";
      url = "https://github.com/polybar/polybar/commit/f99e0b1c7a5b094f5a04b14101899d0cb4ece69d.patch";
      sha256 = "sha256-Mf9R4u1Kq4yqLqTFD5ZoLjrK+GmlvtSsEyRFRCiQ72U=";
    })

    ./remove-hardcoded-etc.diff
  ];

  # Replace hardcoded /etc when copying and reading the default config.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/etc" $out
    substituteAllInPlace src/utils/file.cpp
  '';

  postInstall = ''
    remove-references-to -t ${stdenv.cc} $out/bin/polybar
  ''
  + (lib.optionalString i3Support ''
    wrapProgram $out/bin/polybar \
      --prefix PATH : "${i3}/bin"
  '');

  meta = {
    homepage = "https://polybar.github.io/";
    changelog = "https://github.com/polybar/polybar/releases/tag/${finalAttrs.version}";
    description = "Fast and easy-to-use tool for creating status bars";
    longDescription = ''
      Polybar aims to help users build beautiful and highly customizable
      status bars for their desktop environment, without the need of
      having a black belt in shell scripting.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      afldcr
      moni
    ];
    mainProgram = "polybar";
    platforms = lib.platforms.linux;
  };
})
