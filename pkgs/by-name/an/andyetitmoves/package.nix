{
  lib,
  stdenv,
  fetchurl,
  libvorbis,
  libogg,
  libtheora,
  SDL,
  libxft,
  SDL_image,
  zlib,
  libx11,
  libpng12,
  libGLU,
  libGL,
  openal,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  commercialVersion ? false,
  waylandSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "andyetitmoves";
  version = "1.2.2";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then
      let
        postfix = if stdenv.hostPlatform.system == "i686-linux" then "i386" else "x86_64";
        commercialName = "andyetitmoves-${finalAttrs.version}_${postfix}.tar.gz";
        demoUrl = "http://www.andyetitmoves.net/demo/andyetitmovesDemo-${finalAttrs.version}_${postfix}.tar.gz";
      in
      if commercialVersion then
        requireFile {
          message = ''
            We cannot download the commercial version automatically, as you require a license.
            Once you bought a license, you need to add your downloaded version to the nix store.
            You can do this by using "nix-prefetch-url file:///$PWD/${commercialName}" in the
            directory where you saved it.
          '';
          name = commercialName;
          hash =
            if stdenv.hostPlatform.system == "i686-linux" then
              "sha256-AcCt/sKK4IIkPmWAmhkMXdqdZYHgYLuy5NPvFmv9m5c="
            else
              "sha256-FIvlEJi9rBsC7keNvW/URh8ku7azEIyP00jNpLAJH+0=";
        }
      else
        fetchurl {
          url = demoUrl;
          hash =
            if stdenv.hostPlatform.system == "i686-linux" then
              "sha256-RRSoTz/iK0VWU8AhRsOz1xWjfvJlZana0rAAvHLeJDg="
            else
              "sha256-ZJOuT95+Bp5Bw6exHIRshshMKJ8okbIGpuuIBZQP5FU=";
        }
    else
      throw "`andyetitmoves`: nix package only supports linux on 32 or 64-bit x86.";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libvorbis
    libogg
    libtheora
    SDL
    libxft
    SDL_image
    zlib
    libx11
    libpng12
    libGLU
    libGL
    openal
  ];

  installPhase = ''
    mkdir -p $out/{opt/andyetitmoves,bin,lib}
    cp -r * $out/opt/andyetitmoves/

    # Nuke ancient bundled standard libraries to prevent Mesa crashes
    rm -f $out/opt/andyetitmoves/lib/libstdc++.so*
    rm -f $out/opt/andyetitmoves/lib/libgcc_s.so*

    # Create a compat symlink for the legacy Theora library
    ln -s ${libtheora}/lib/libtheoradec.so $out/lib/libtheora.so.0

    binName=${if commercialVersion then "AndYetItMoves" else "AndYetItMovesDemo"}

    # The permanent legacy compatibility wrapper
    makeWrapper $out/opt/andyetitmoves/lib/$binName $out/bin/$binName \
      --run "cd $out/opt/andyetitmoves" \
      --set SDL_VIDEODRIVER ${if waylandSupport then "wayland" else "x11"} \
      --set MESA_GL_VERSION_OVERRIDE 2.1 \
      --set MESA_GLSL_VERSION_OVERRIDE 120 \
      --set allow_rgb10_configs false
  '';

  meta = {
    description = "Physics/Gravity Platform game";
    longDescription = ''
      And Yet It Moves is an award-winning physics-based platform game in which players rotate the game world at will to solve challenging puzzles. Tilting the world turns walls into floors, slides into platforms, and stacks of rocks into dangerous hazards.
    '';
    homepage = "http://www.andyetitmoves.net/";
    license = lib.licenses.unfree;
  };
})
