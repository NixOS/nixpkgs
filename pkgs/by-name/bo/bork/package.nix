{
  callPackage,
  curl,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  zig_0_14,
}:

let
  zig = zig_0_14;
in
stdenvNoCC.mkDerivation {
  name = "bork";
  version = "0.4.0-unstable-2025-04-18";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "bork";
    rev = "ae7c7a82fc717d31dd9240300e5ca84f069dc453";
    hash = "sha256-HAW5/FXgAwD+N48H+K2salN7o125i012GB1kB4CnXgQ=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = [
    curl
  ];

  zigBuildFlags = [ "--release=fast" ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "TUI chat client tailored for livecoding on Twitch";
    homepage = "https://github.com/kristoff-it/bork";
    changelog = "https://github.com/kristoff-it/bork/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonhermansen ];
    platforms = lib.platforms.unix;
    mainProgram = "bork";
  };
}
