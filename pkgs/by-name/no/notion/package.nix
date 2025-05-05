{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  gettext,
  groff,
  libSM,
  libX11,
  libXext,
  libXft,
  libXinerama,
  libXrandr,
  lua,
  makeWrapper,
  pkg-config,
  readline,
  which,
  xmessage,
  xterm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "notion";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "notion";
    tag = finalAttrs.version;
    hash = "sha256-Ll4thDS8fHxkm2IuGjePPVPyPPrz7yDzpKVloFuk/yE=";
  };

  postPatch = ''
    # Fix build failure due missing headers
    sed -i '1i#define _POSIX_C_SOURCE 200809L' mod_notionflux/notionflux/notionflux.c
    sed -i '2i#include <stdio.h>' mod_notionflux/notionflux/notionflux.c
    sed -i '3i#include <string.h>' mod_notionflux/notionflux/notionflux.c

    # error: 'PATH_MAX' undeclared
    sed 1i'#include <linux/limits.h>' -i mod_notionflux/notionflux/notionflux.c
  '';

  nativeBuildInputs = [
    gettext
    groff
    lua
    makeWrapper
    pkg-config
    which
  ];

  buildInputs = [
    fontconfig
    libSM
    libX11
    libXext
    libXft
    libXinerama
    libXrandr
    lua
    readline
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  buildFlags = [
    "LUA_DIR=${lua}"
    "X11_PREFIX=/no-such-path"
  ];

  makeFlags = [
    "NOTION_RELEASE=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${
        lib.makeBinPath [
          xmessage
          xterm
        ]
      }" \
  '';

  meta = {
    description = "Tiling tabbed window manager";
    homepage = "https://notionwm.net";
    license = lib.licenses.lgpl21;
    mainProgram = "notion";
    maintainers = with lib.maintainers; [
      jfb
      raboof
      NotAShelf
    ];
    platforms = lib.platforms.linux;
  };
})
