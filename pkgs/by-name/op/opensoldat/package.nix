{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fpc,
  makeWrapper,
  SDL2,
  freetype,
  physfs,
  openal,
  gamenetworkingsockets,
  xorg,
  autoPatchelfHook,
  cmake,
  python3,
}:

let
  base = stdenv.mkDerivation rec {
    pname = "opensoldat-base";
    version = "unstable-2025-10-16";

    src = fetchFromGitHub {
      name = "base";
      owner = "opensoldat";
      repo = "base";
      rev = "5b6e5bef23f5c0d58fb1d4d887b9b94ebcf799b4";
      sha256 = "sha256-k3P4xSO7DgXn6EzDqlo+RHHTuMDPNvG5y+2iXqguh/M=";
    };

    nativeBuildInputs = [ python3 ];

    buildPhase = ''
      python create_smod.py
    '';

    installPhase = ''
      install -Dm644 soldat.smod -t $out/share/opensoldat
      install -Dm644 play-regular.ttf -t $out/share/opensoldat
    '';

    meta = with lib; {
      description = "Opensoldat's base game content";
      license = licenses.cc-by-40;
      platforms = platforms.all;
      inherit (src.meta) homepage;
    };
  };

in

stdenv.mkDerivation rec {
  pname = "opensoldat";
  version = "unstable-2025-10-21";

  src = fetchFromGitHub {
    name = "opensoldat";
    owner = "opensoldat";
    repo = "opensoldat";
    rev = "220468f558f6932ba1dc180a9ef84913d07ab324";
    sha256 = "sha256-BnTLuc/wucFNKh0jnVggpHNvLj/1kqL7i7fF7ORiIZA=";
  };

  nativeBuildInputs = [
    fpc
    makeWrapper
    autoPatchelfHook
    cmake
  ];

  cmakeFlags = [
    "-DADD_ASSETS=OFF" # We provide base's smods via nix
    "-DBUILD_GNS=OFF" # Don't build GameNetworkingSockets as an ExternalProject
  ];

  buildInputs = [
    SDL2
    freetype
    physfs
    openal
    gamenetworkingsockets
    xorg.libX11
  ];
  # TODO(@sternenseemann): set proper rpath via cmake, so we don't need autoPatchelfHook
  runtimeDependencies = [ xorg.libX11 ];

  # make sure opensoldat{,server} find their game archive,
  # let them write their state and configuration files
  # to $XDG_CONFIG_HOME/soldat/soldat{,server} unless
  # the user specifies otherwise.
  # Add 'open' prefix to configuration directories
  postInstall = ''
    for p in soldatserver soldat; do
      configDir="\''${XDG_CONFIG_HOME:-\$HOME/.config}/opensoldat/open$p"
      oldConfigDir="\''${XDG_CONFIG_HOME:-\$HOME/.config}/soldat/$p"

      wrapProgram $out/bin/open$p \
        --run "mkdir -p \"''${XDG_CONFIG_HOME:-\$HOME/.config}/opensoldat\"" \
        --run "[ -d \"$oldConfigDir\" ] && [ -d \"$configDir\" ] && echo Please migrate \"$oldConfigDir\" to \"$configDir\" manually. && exit 1" \
        --run "[ -d \"$oldConfigDir\" ] && [ ! -d \"$configDir\" ] && mv \"$oldConfigDir\" \"$configDir\"" \
        --run "mkdir -p \"$configDir\"; rmdir \"$oldConfigDir\" 2>/dev/null || true" \
        --add-flags "-fs_portable 0" \
        --add-flags "-fs_userpath \"$configDir\"" \
        --add-flags "-fs_basepath \"${base}/share/opensoldat\""
    done
  '';

  meta = with lib; {
    description = "Unique 2D (side-view) multiplayer action game";
    license = [
      licenses.mit
      base.meta.license
    ];
    inherit (src.meta) homepage;
    maintainers = [ maintainers.sternenseemann ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    # portability currently mainly limited by fpc
    # in nixpkgs which doesn't work on darwin,
    # aarch64 and arm support should be possible:
    # https://github.com/opensoldat/opensoldat/issues/45
  };
}
