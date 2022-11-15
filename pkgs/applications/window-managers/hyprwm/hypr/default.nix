{ lib
, stdenv
, fetchFromGitHub
, cairo
, cmake
, glib
, gtkmm3
, harfbuzz
, libX11
, libXdmcp
, libxcb
, makeWrapper
, pcre2
, pkg-config
, xcbutilcursor
, xcbutilkeysyms
, xcbutilwm
, xmodmap
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypr";
  version = "unstable-2022-05-25";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "Hypr";
    rev = "3e3d943c446ae77c289611a1a875c8dff8883c1e";
    hash = "sha256-lyaGGm53qxg7WVoFxZ7kerLe12P1N3JbN8nut6oZS50=";
  };

  patches = [
    ./000-dont-set-compiler.diff
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    gtkmm3
    harfbuzz
    libX11
    libXdmcp
    libxcb
    pcre2
    xcbutilcursor
    xcbutilkeysyms
    xcbutilwm
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 Hypr -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/Hypr --prefix PATH : ${lib.makeBinPath [ xmodmap ]}
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A tiling X11 window manager written in modern C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
    broken = stdenv.isDarwin; # xcb/xcb_atom.h not found
    mainProgram = "Hypr";
  };
})
