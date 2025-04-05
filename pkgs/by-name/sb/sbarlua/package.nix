{
  lua54Packages,
  gcc,
  darwin,
  fetchFromGitHub,
  readline,
  lib,
  ...
}:
lua54Packages.buildLuaPackage {
  name = "sbarlua";
  pname = "sbarlua";
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
    sha256 = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };

  buildInputs = [
    gcc
    darwin.apple_sdk.frameworks.CoreFoundation
    readline
  ];

  installPhase = ''
    mkdir -p $out/lib/lua/5.4/
    cp bin/sketchybar.so $out/lib/lua/5.4
  '';

  meta = {
    description = "Lua bindings for configuring Sketchybar macOS Window Manager";
    homepage = "https://github.com/FelixKratz/SbarLua";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ amusingimpala75 ];
    platforms = lib.platforms.darwin;
  };
}
