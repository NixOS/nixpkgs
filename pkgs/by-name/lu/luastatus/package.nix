{
  lib,
  stdenv,
  fetchFromGitHub,
  # Native Build Inputs
  cmake,
  pkg-config,
  makeWrapper,
  # Dependencies
  yajl,
  alsa-lib,
  libpulseaudio,
  glib,
  libnl,
  udev,
  libXau,
  libXdmcp,
  pcre2,
  pcre,
  util-linux,
  libselinux,
  libsepol,
  lua5,
  docutils,
  libxcb,
  libX11,
  xcbutil,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luastatus";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "shdown";
    repo = "luastatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-whO5pjUPaCwEb2GDCIPnTk39MejSQOoRRQ5kdYEQ0Pc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libxcb
    libX11
    xcbutil
    xcbutilwm
    libXdmcp
    libXau
    libpulseaudio
    libnl
    libselinux
    libsepol
    yajl
    alsa-lib
    glib
    udev
    pcre2
    pcre
    util-linux
    lua5
    docutils
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.1.3)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    wrapProgram $out/bin/luastatus-stdout-wrapper \
      --prefix LUASTATUS : $out/bin/luastatus

    wrapProgram $out/bin/luastatus-i3-wrapper \
      --prefix LUASTATUS : $out/bin/luastatus

    wrapProgram $out/bin/luastatus-lemonbar-launcher \
      --prefix LUASTATUS : $out/bin/luastatus
  '';

  meta = with lib; {
    description = "Universal status bar content generator";
    homepage = "https://github.com/shdown/luastatus";
    changelog = "https://github.com/shdown/luastatus/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kashw2 ];
    platforms = platforms.linux;
  };
})
