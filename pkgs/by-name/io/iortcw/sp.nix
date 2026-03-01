{
  lib,
  stdenv,
  fetchFromGitHub,
  opusfile,
  libogg,
  SDL2,
  openal,
  freetype,
  libjpeg,
  curl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iortcw-sp";
  version = "1.51c";

  src = fetchFromGitHub {
    owner = "iortcw";
    repo = "iortcw";
    rev = finalAttrs.version;
    sha256 = "0g5wgqb1gm34pd05dj2i8nj3qhsz0831p3m7bsgxpjcg9c00jpyw";
  };

  enableParallelBuilding = true;

  sourceRoot = "${finalAttrs.src.name}/SP";

  makeFlags = [
    "USE_INTERNAL_LIBS=0"
    "COPYDIR=${placeholder "out"}/opt/iortcw"
    "USE_OPENAL_DLOPEN=0"
    "USE_CURL_DLOPEN=0"
  ];

  installTargets = [ "copyfiles" ];

  buildInputs = [
    opusfile
    libogg
    SDL2
    freetype
    libjpeg
    openal
    curl
  ];
  nativeBuildInputs = [ makeWrapper ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-I${lib.getInclude SDL2}/include/SDL2"
      "-I${opusfile.dev}/include/opus"
    ];
    NIX_CFLAGS_LINK = toString [
      "-lSDL2"
    ];
  };

  postInstall = ''
    for i in `find $out/opt/iortcw -maxdepth 1 -type f -executable`; do
      makeWrapper $i $out/bin/`basename $i` --chdir "$out/opt/iortcw"
    done
  '';

  meta = {
    description = "Single player version of game engine for Return to Castle Wolfenstein";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rjpcasalino ];
  };
})
