{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libxcb
, libxkbcommon
, wayland
, wayland-protocols
, wlroots
, enable-xwayland ? true, xwayland, libX11
, patches ? [ ]
, conf ? null
, writeText
}:

stdenv.mkDerivation rec {
  pname = "dwl";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "djpohly";
    repo = pname;
    rev = "v${version}";
    sha256 = "QoKaeF5DbSX0xciwc/0VKpubn/001cJjoZ+UzVDX4qE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxcb
    libxkbcommon
    wayland
    wayland-protocols
    wlroots
  ] ++ lib.optionals enable-xwayland [ xwayland libX11 ];

  # Allow users to set their own list of patches
  inherit patches;

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
