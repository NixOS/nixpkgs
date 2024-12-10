{ config
, cairo
, cmake
, fetchFromGitHub
, libuv
, libXdmcp
, libpthreadstubs
, libxcb
, pcre
, pkg-config
, python3
, python3Packages # sphinx-build
, lib
, stdenv
, xcbproto
, xcbutil
, xcbutilcursor
, xcbutilimage
, xcbutilrenderutil
, xcbutilwm
, xcbutilxrm
, makeWrapper
, removeReferencesTo
, alsa-lib
, curl
, libmpdclient
, libpulseaudio
, wirelesstools
, libnl
, i3
, jsoncpp

  # override the variables ending in 'Support' to enable or disable modules
, alsaSupport ? true
, githubSupport ? false
, mpdSupport ? false
, pulseSupport ? config.pulseaudio or false
, iwSupport ? false
, nlSupport ? true
, i3Support ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polybar";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "polybar";
    repo = "polybar";
    rev = finalAttrs.version;
    hash = "sha256-5PYKl6Hi4EYEmUBwkV0rLiwxNqIyR5jwm495YnNs0gI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.sphinx
    removeReferencesTo
  ] ++ lib.optional i3Support makeWrapper;

  buildInputs = [
    cairo
    libuv
    libXdmcp
    libpthreadstubs
    libxcb
    pcre
    python3
    xcbproto
    xcbutil
    xcbutilcursor
    xcbutilimage
    xcbutilrenderutil
    xcbutilwm
    xcbutilxrm
  ] ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional githubSupport curl
  ++ lib.optional mpdSupport libmpdclient
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional iwSupport wirelesstools
  ++ lib.optional nlSupport libnl
  ++ lib.optionals i3Support [ jsoncpp i3 ];

  patches = [ ./remove-hardcoded-etc.diff ];

  # Replace hardcoded /etc when copying and reading the default config.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/etc" $out
    substituteAllInPlace src/utils/file.cpp
  '';

  postInstall = ''
    remove-references-to -t ${stdenv.cc} $out/bin/polybar
  '' + (lib.optionalString i3Support ''
    wrapProgram $out/bin/polybar \
      --prefix PATH : "${i3}/bin"
  '');

  meta = with lib; {
    homepage = "https://polybar.github.io/";
    changelog = "https://github.com/polybar/polybar/releases/tag/${finalAttrs.version}";
    description = "Fast and easy-to-use tool for creating status bars";
    longDescription = ''
      Polybar aims to help users build beautiful and highly customizable
      status bars for their desktop environment, without the need of
      having a black belt in shell scripting.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ afldcr Br1ght0ne moni ];
    mainProgram = "polybar";
    platforms = platforms.linux;
  };
})
