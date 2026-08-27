{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-cmp";
  version = "20";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "camgunz";
    repo = "cmp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K42M6QhGrZgVWANSoVu62iC/uYfUjOKwgLS3m7U8Qu0=";
  };

  env.CMPCFLAGS = "-std=c99 -o libcmp.so";

  buildPhase = ''
    runHook preBuild

    $CC $CFLAGS $CMPCFLAGS -g -I. -c cmp.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,obj,include}/cmp
    cp ./libcmp.so "$out/lib/libcmp.so"
    cp ./cmp.h "$out/include/cmp/cmp.h"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the MessagePack serialization format in C";
    homepage = "https://github.com/camgunz/cmp";
    changelog = "https://github.com/camgunz/cmp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
