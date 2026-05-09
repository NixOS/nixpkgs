{
  lib,
  stdenv,
  fetchFromGitHub,
  opusfile,
  libogg,
  libvorbis,
  SDL2,
  openal,
  freetype,
  libjpeg,
  curl,
  makeWrapper,
  bc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iortcw-sp";
  version = "1.51d";

  src = fetchFromGitHub {
    owner = "iortcw";
    repo = "iortcw";
    rev = "438e7d413b5f7277187c35b032eb0ef9093ae778";
    hash = "sha256-ME8b6drkZek0GJ3YPT5E5YW+aTHGAKLRPsE7hM3f8bE=";
  };

  # Constexpr is a reserved keyword since C++11 that can't be overwritten. Replacing constexpr with
  # const_expr is necessary in this case for the build to function.
  postPatch = ''
    substituteInPlace code/tools/lcc/src/{c.h,init.c,simp.c,stmt.c} \
      --replace-fail 'constexpr' 'const_expr'
    substituteInPlace Makefile \
      --replace-fail "gcc" "cc"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
       --replace-fail "-framework SDL2" "-lSDL2"
  '';

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
    libvorbis
    SDL2
    freetype
    libjpeg
    openal
    curl
  ];
  nativeBuildInputs = [
    makeWrapper
    bc
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-I${lib.getInclude SDL2}/include/SDL2"
      "-I${opusfile.dev}/include/opus"
    ];
    NIX_CFLAGS_LINK = toString [
      "-lSDL2"
    ];
  };

  postInstall =
    let
      arch =
        if stdenv.hostPlatform.isx86_64 then
          "x86_64"
        else if stdenv.hostPlatform.isAarch64 then
          "arm64"
        else
          throw "Unsupported architecture";

      bins = [
        "iowolfded"
        "iowolfsp"
        "iowolfmp"
      ];
    in
    ''
      cd "$out/opt/iortcw"
      mkdir -p "$out/bin"

      for name in ${lib.escapeShellArgs bins}; do
        nameWithExt="$name.${arch}"

        [ -x "$nameWithExt" ] || continue

        makeWrapper "$out/opt/iortcw/$nameWithExt" "$out/bin/$name" \
          --chdir "$out/opt/iortcw"
      done
    '';

  meta = {
    description = "Single player version of game engine for Return to Castle Wolfenstein";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      r4v3n6101
      rjpcasalino
    ];
  };
})
