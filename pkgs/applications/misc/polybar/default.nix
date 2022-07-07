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
, i3-gaps
, jsoncpp

  # override the variables ending in 'Support' to enable or disable modules
, alsaSupport ? true
, githubSupport ? false
, mpdSupport ? false
, pulseSupport ? config.pulseaudio or false
, iwSupport ? false
, nlSupport ? true
, i3Support ? false
, i3GapsSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "polybar";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-FKkPSAEMzptnjJq3xTk+fpD8XjASQ3smX5imstDyLNE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.sphinx
    removeReferencesTo
  ] ++ lib.optional (i3Support || i3GapsSupport) makeWrapper;

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
  ++ lib.optional (i3Support || i3GapsSupport) jsoncpp
  ++ lib.optional i3Support i3
  ++ lib.optional i3GapsSupport i3-gaps;

  patches = [ ./remove-hardcoded-etc.diff ];

  # Replace hardcoded /etc when copying and reading the default config.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/etc" $out
    substituteAllInPlace src/utils/file.cpp
  '';

  postInstall =
    if i3Support then ''
      wrapProgram $out/bin/polybar \
        --prefix PATH : "${i3}/bin"
    ''
    else if i3GapsSupport
    then ''
      wrapProgram $out/bin/polybar \
        --prefix PATH : "${i3-gaps}/bin"
    ''
    else "";

  postFixup = ''
    remove-references-to -t ${stdenv.cc} $out/bin/polybar
  '';

  meta = with lib; {
    homepage = "https://polybar.github.io/";
    changelog = "https://github.com/polybar/polybar/releases/tag/${version}";
    description = "A fast and easy-to-use tool for creating status bars";
    longDescription = ''
      Polybar aims to help users build beautiful and highly customizable
      status bars for their desktop environment, without the need of
      having a black belt in shell scripting.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ afldcr Br1ght0ne fortuneteller2k ckie ];
    platforms = platforms.linux;
  };
}
