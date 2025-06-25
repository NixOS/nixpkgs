{
  lib,
  stdenv,
  fetchurl,
  SDL2,
  glui,
  libGLU,
  libGL,
  buildFHSEnv,
}:
let
  bigpemu-unwrapped = stdenv.mkDerivation rec {
    pname = "BigPEmu";
    version = "1.19";
    src = fetchurl {
      url = "https://www.richwhitehouse.com/jaguar/builds/BigPEmu_Linux64_v${
        builtins.replaceStrings [ "." ] [ "" ] version
      }.tar.gz";
      hash = "sha256-kiZ9yzDRkDLzd5EtjIn32TL27Y2GG8ysG0zTM1JRyTU=";
    };

    installPhase = ''
      mkdir -p $out/bin
      tar -xvf $src -C $out/bin --strip-components=1
    '';

  };
in
buildFHSEnv {
  name = "bigpemu";
  version = bigpemu-unwrapped.version;
  targetPkgs = pkgs: [
    glui
    libGL
    libGLU
    SDL2
  ];
  meta = {
    description = "Atari Jaguar Emulator (BigPEmu) by Richard Whitehouse";
    homepage = "https://www.richwhitehouse.com/jaguar/index.php";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tombert
      hughobrien
    ];
    platforms = with lib.platforms; [ "x86_64-linux" ];
  };
  runScript = "${bigpemu-unwrapped}/bin/bigpemu";
  passthru = {
    unwrapped = bigpemu-unwrapped;
    updateScript = ./update.sh;
  };
}
