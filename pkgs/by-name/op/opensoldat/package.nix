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
    version = "unstable-2022-10-29";

    src = fetchFromGitHub {
      name = "base";
      owner = "opensoldat";
      repo = "base";
      rev = "5f880cdee5b50168d9d4d79026623b5624af9e40";
      sha256 = "sha256-nRUg4L6gfzz9dCxGs4pr3Xr0DVcuKn6At82ALOgG8IQ=";
    };

    nativeBuildInputs = [ python3 ];

    buildPhase = ''
      python create_smod.py
    '';

    patches = [
      (fetchpatch {
        # https://github.com/opensoldat/base/pull/27
        name = "zip-timestamps.patch";
        url = "https://github.com/opensoldat/base/commit/5d5312728e8a5a455b1f0be8b75ffe096573dfdb.patch";
        hash = "sha256-RjAMg4d1RWKTP22AenjPl1vfIr7ClmNfkQYjmBM0oS4=";
      })
    ];

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
  version = "unstable-2024-04-21";

  src = fetchFromGitHub {
    name = "opensoldat";
    owner = "opensoldat";
    repo = "opensoldat";
    rev = "ca26c2a94a57b380ca26b990d8d4626289d627f7";
    sha256 = "sha256-LaaUal8CkdAlfnThvauAkBunE+E1ETSFDL/ZgKtGw+w=";
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

  patches = [
    (fetchpatch {
      # https://github.com/opensoldat/opensoldat/pull/171
      name = "stb-bump-cmake.patch";
      url = "https://github.com/opensoldat/opensoldat/commit/6d619849af70ad8b35dad6d51e656ac45165d4c3.patch";
      hash = "sha256-0WKWLuhoN4vo6gysvARzZooofQ+UIRKh7fG7/PoCB+E=";
    })
    (fetchpatch {
      # https://github.com/opensoldat/opensoldat/pull/172
      name = "gns-condition.patch";
      url = "https://github.com/opensoldat/opensoldat/commit/a19e33c0c950b7c538439334427f8e75011a0d88.patch";
      hash = "sha256-iC9elDl8QB3Cs/dD6lFZoNHRYcsgoZOdg2kqSgmqAx4=";
    })
  ];

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
