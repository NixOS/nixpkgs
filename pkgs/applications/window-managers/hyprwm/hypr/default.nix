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
, xcbutil
, xmodmap
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypr";
  version = "unstable-2023-01-26";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "Hypr";
    rev = "af4641847b578b233a6f06806f575b3f320d74da";
    hash = "sha256-FUKR5nceEhm9GWa61hHO8+y4GBz7LYKXPB0OpQcQ674=";
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
    xcbutil
  ];

  # src/ewmh/ewmh.cpp:67:28: error: non-constant-expression cannot be narrowed from type 'int' to 'uint32_t' (aka 'unsigned int') in initializer list
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-c++11-narrowing";

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
    description = "Tiling X11 window manager written in modern C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
    mainProgram = "Hypr";
  };
})
