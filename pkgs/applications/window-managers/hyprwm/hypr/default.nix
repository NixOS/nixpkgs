{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "unstable-2022-05-25";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "Hypr";
    rev = "3e3d943c446ae77c289611a1a875c8dff8883c1e";
    hash = "sha256-lyaGGm53qxg7WVoFxZ7kerLe12P1N3JbN8nut6oZS50=";
  };

  patches = [
    ./000-dont-set-compiler.diff
    # TODO: remove on next release
    (fetchpatch {
      url = "https://github.com/hyprwm/Hypr/commit/08d6af2caf882247943f0e8518ad782f35d1aba4.patch";
      sha256 = "sha256-WjR12ZH8CE+l9xSeQUAPYW5r5HzoPpod5YqDPJTdTY8=";
    })
    (fetchpatch {
      url = "https://github.com/hyprwm/Hypr/commit/7512a3ab91865b1e11b8c4a9dfdffb25c2b153de.patch";
      sha256 = "sha256-0Hq5n115z0U44op7A1FO9tUOeMEPV0QgD5E5zcmend0=";
    })
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
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-c++11-narrowing";

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
    mainProgram = "Hypr";
  };
})
