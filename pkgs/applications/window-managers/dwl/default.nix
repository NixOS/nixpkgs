{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libinput
, libxcb
, libxkbcommon
, wayland
, wayland-protocols
, wlroots
, enable-xwayland ? true, xwayland, libX11
, patches ? [ ]
, conf ? null
, writeText
, fetchpatch
}:

let
  # Add two patches to fix compile errors with wlroots 0.13:
  totalPatches = patches ++ [
    # Fix the renamed constant WLR_KEY_PRESSED => WL_KEYBOARD_KEY_STATE_PRESSED
    # https://github.com/djpohly/dwl/pull/66
    (fetchpatch {
      url = "https://github.com/djpohly/dwl/commit/a42613db9d9f6debfa4fb2363d75af9457d238ed.patch";
      sha256 = "0h76hx1fhazi07gqg7sljh13f91v6bvjy7m9qqmimhvqgfwdcc0j";
    })
    # Use the new signature for wlr_backend_autocreate, which removes an argument:
    # https://github.com/djpohly/dwl/pull/76
    (fetchpatch {
      url = "https://github.com/djpohly/dwl/commit/0ff13cf216056a36a261f4eed53c6a864989a9fb.patch";
      sha256 = "18clpdb4il1vxf1b0cx0qrwild68s9dism8ab66zpmvxs5qag2dm";
    })
  ];
in

stdenv.mkDerivation rec {
  pname = "dwl";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "djpohly";
    repo = pname;
    rev = "v${version}";
    sha256 = "gUaFTkpIQDswEubllMgvxPfCaEYFO7mODzjPyW7XsGQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    libxcb
    libxkbcommon
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
    platforms = with platforms; linux;
  };
}
# TODO: custom patches from upstream website
# TODO: investigate the modifications in the upstream unstable version
