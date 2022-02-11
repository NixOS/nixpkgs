{ lib
, stdenv
, fetchFromGitHub
, libinput
, libxcb
, libxkbcommon
, pixman
, pkg-config
, wayland
, wayland-protocols
, wlroots
, writeText
, enable-xwayland ? true, xwayland, libX11
, conf ? null
, patches ? [ ]
}:

let
  totalPatches = patches ++ [ ];
in

stdenv.mkDerivation rec {
  pname = "dwl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "djpohly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T2GqDehBNO8eublqZUmA5WADjnwElzT+bp9Dp1bqSgg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots
  ] ++ lib.optionals enable-xwayland [
    libX11
    xwayland
  ];

  # Allow users to set their own list of patches
  patches = totalPatches;

  # Last line of config.mk enables XWayland
  prePatch = lib.optionalString enable-xwayland ''
    sed -i -e '$ s|^#||' config.mk
  '';

  # Allow users to set an alternative config.def.h
  postPatch = let
    configFile = if lib.isDerivation conf || builtins.isPath conf
                 then conf
                 else writeText "config.def.h" conf;
  in lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  NIX_CFLAGS_COMPILE = [
    # https://github.com/djpohly/dwl/issues/186
    "-Wno-error=unused-result"
  ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -d $out/bin
    install -m755 dwl $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/djpohly/dwl/";
    description = "Dynamic window manager for Wayland";
    longDescription = ''
      dwl is a compact, hackable compositor for Wayland based on wlroots. It is
      intended to fill the same space in the Wayland world that dwm does in X11,
      primarily in terms of philosophy, and secondarily in terms of
      functionality. Like dwm, dwl is:

      - Easy to understand, hack on, and extend with patches
      - One C source file (or a very small number) configurable via config.h
      - Limited to 2000 SLOC to promote hackability
      - Tied to as few external dependencies as possible
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
}
# TODO: custom patches from upstream website
