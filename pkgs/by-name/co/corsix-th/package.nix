{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  doxygen,
  ffmpeg,
  freetype,
  libpng,
  lua5_2_compat,
  makeWrapper,
  SDL2,
  SDL2_mixer,
  timidity,
  zlib,
  # Update
  nix-update-script,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "corsix-th";
  version = "0.70.1";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yS1SsmCyKOhYyCQxGcMImmYCe8Dv62FFMwAU/jQd2hI=";
  };

  patches = [
    ./darwin-cmake-no-fixup-bundle.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    makeWrapper
  ];

  buildInputs =
    let
      luaEnv = lua.withPackages (
        p: with p; [
          luafilesystem
          lpeg
          luasec
          luasocket
        ]
      );
    in
    [
      curl
      ffmpeg
      freetype
      libpng
      lua
      luaEnv
      SDL2
      SDL2_mixer
      timidity
      zlib
    ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeBool "WITH_MIDI_DEVICE" false)
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/corsix-th \
      --set LUA_PATH "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/CorsixTH.app $out/Applications
      wrapProgram $out/Applications/CorsixTH.app/Contents/MacOS/CorsixTH \
        --set LUA_PATH "$LUA_PATH" \
        --set LUA_CPATH "$LUA_CPATH"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reimplementation of the 1997 Bullfrog business sim Theme Hospital";
    mainProgram = "corsix-th";
    homepage = "https://corsixth.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hughobrien
      matteopacini
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
