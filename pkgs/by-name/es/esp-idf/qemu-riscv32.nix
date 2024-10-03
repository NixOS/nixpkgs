{
  autoPatchelfHook,
  fetchurl,
  glib,
  lib,
  libgcrypt,
  libslirp,
  libz,
  SDL2,
  sourceInfo ?
    (builtins.fromJSON (builtins.readFile ./source-info.json)).tools.${stdenv.system}.qemu-riscv32,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (sourceInfo) pname version;
  src = fetchurl { inherit (sourceInfo) name url sha256; };

  dontBuild = true;
  installPhase = "cp -R . $out";

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool \
      -change \
        /opt/homebrew/opt/libgcrypt/lib/libgcrypt.20.dylib \
        ${lib.getLib libgcrypt}/lib/libgcrypt.20.dylib \
      -change \
        /opt/homebrew/opt/sdl2/lib/libSDL2-2.0.0.dylib \
        ${lib.getLib SDL2}/lib/libSDL2-2.0.0.dylib \
      -change \
        /opt/homebrew/opt/libslirp/lib/libslirp.0.dylib \
        ${lib.getLib libslirp}/lib/libslirp.0.dylib \
      $out/bin/qemu-system-riscv32
  '';

  nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;
  buildInputs = [
    glib
    libgcrypt
    libslirp
    libz
    SDL2
  ];
}
