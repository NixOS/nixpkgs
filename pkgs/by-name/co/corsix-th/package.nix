{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  doxygen,
  ffmpeg,
  freetype,
  lua,
  makeWrapper,
  SDL2,
  SDL2_mixer,
  timidity,
  # Update
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corsix-th";
  version = "0.69.1";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jrf3PhgnJUBGy+ZcSPjU5tQFyuTmnn5+8P6LujsoSAg=";
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
      lua
      luaEnv
      SDL2
      SDL2_mixer
      timidity
    ];

  cmakeFlags = [ "-Wno-dev" ];

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

  meta = with lib; {
    description = "Reimplementation of the 1997 Bullfrog business sim Theme Hospital";
    mainProgram = "corsix-th";
    homepage = "https://corsixth.com/";
    license = licenses.mit;
    maintainers = with maintainers; [
      hughobrien
      matteopacini
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
