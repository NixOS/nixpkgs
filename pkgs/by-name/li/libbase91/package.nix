{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbase91";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aul68hDvEriSOUAutJkboeP7rzLcZGC7va39GVqKmig=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildPhase =
    let
      sharedLib = if stdenv.hostPlatform.isDarwin then "libbase91.dylib" else "libbase91.so";
      sharedFlags =
        if stdenv.hostPlatform.isDarwin then
          "-dynamiclib -Wl,-install_name,$out/lib/libbase91.dylib"
        else
          "-shared -Wl,-soname,libbase91.so";
    in
    ''
      runHook preBuild
      $CC -O2 -fPIC ${sharedFlags} -o ${sharedLib} base91.c
      $CC -O2 -c base91.c -o base91.o
      $AR crs libbase91.a base91.o
      runHook postBuild
    '';

  installPhase =
    let
      sharedLib = if stdenv.hostPlatform.isDarwin then "libbase91.dylib" else "libbase91.so";
    in
    ''
      runHook preInstall
      mkdir -p $out/lib $out/include
      cp ${sharedLib} libbase91.a $out/lib/
      cp base91.h $out/include/
      runHook postInstall
    '';

  meta = {
    description = "basE91 C library";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ douzebis ];
    platforms = lib.platforms.unix;
  };
})
