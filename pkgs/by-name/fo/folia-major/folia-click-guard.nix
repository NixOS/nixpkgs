{
  lib,
  stdenv,
  swift,

  version,
  src,
  meta,
}:

# macOS wallpaper click guard, upstream builds it in packaging/macos/build-desktop-click-guard.mjs
stdenv.mkDerivation (finalAttrs: {
  pname = "folia-click-guard";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/packaging/macos/desktop-click-guard";

  nativeBuildInputs = [ swift ];

  buildPhase = ''
    runHook preBuild
    swiftc -O -emit-library -module-name FoliaClickGuard \
      -target ${stdenv.hostPlatform.swift.triple} \
      ClickGuard.swift -o libfolia_click_guard.dylib
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 libfolia_click_guard.dylib -t $out/lib
    runHook postInstall
  '';

  meta =
    removeAttrs meta [
      "mainProgram"
      "sourceProvenance"
    ]
    // {
      description = "Stage Manager click guard for the macOS wallpaper mode of Folia";
      homepage = "https://github.com/chthollyphile/folia-major/tree/${finalAttrs.src.tag}/packaging/macos/desktop-click-guard";
      platforms = lib.platforms.darwin;
    };
})
