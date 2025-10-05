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
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "notion";
    tag = finalAttrs.version;
    hash = "sha256-L7WL8zn1Qkf5sqrhqZJqFe4B1l9ULXI3pt3Jpc87huk=";
  };

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
      raboof
      NotAShelf
    ];
    platforms = lib.platforms.linux;
  };
})
