{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  zip,
  makeWrapper,
  SDL2,
  freetype,
  physfs,
  openal,
  gamenetworkingsockets,
  xorg,
  autoPatchelfHook,
  cmake,
}:

let
  base = stdenv.mkDerivation rec {
    pname = "opensoldat-base";
    version = "unstable-2021-09-05";

    src = fetchFromGitHub {
      name = "base";
      owner = "opensoldat";
      repo = "base";
      rev = "6c74d768d511663e026e015dde788006c74406b5";
      sha256 = "175gmkdccy8rnkd95h2zqldqfydyji1hfby8b1qbnl8wz4dh08mz";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      sh create_smod.sh
    '';

    installPhase = ''
      install -Dm644 soldat.smod -t $out/share/soldat
      install -Dm644 client/play-regular.ttf -t $out/share/soldat
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
  version = "unstable-2022-07-02";

  src = fetchFromGitHub {
    name = "opensoldat";
    owner = "opensoldat";
    repo = "opensoldat";
    rev = "9574f5791b7993067f03d2df03d625908bc3762f";
    sha256 = "0kyxzikd4ngx3nshjw0411x61zqq1b7l01lxw41rlcy4nad3r0vi";
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

  # make sure soldat{,server} find their game archive,
  # let them write their state and configuration files
  # to $XDG_CONFIG_HOME/soldat/soldat{,server} unless
  # the user specifies otherwise.
  # TODO(@sternenseemann): rename config dir to opensoldat
  postInstall = ''
    for p in $out/bin/soldatserver $out/bin/soldat; do
      configDir="\''${XDG_CONFIG_HOME:-\$HOME/.config}/soldat/$(basename "$p")"

      wrapProgram "$p" \
        --run "mkdir -p \"$configDir\"" \
        --add-flags "-fs_portable 0" \
        --add-flags "-fs_userpath \"$configDir\"" \
        --add-flags "-fs_basepath \"${base}/share/soldat\""
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
