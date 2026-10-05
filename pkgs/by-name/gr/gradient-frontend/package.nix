{
  dart-sass,
  fetchPnpmDeps,
  gradient,
  lib,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gradient-frontend";
  inherit (gradient) version src;
  __structuredAttrs = true;
  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/frontend";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-1JNu6GIWdALMi3ngGBL/m+0JH8/MeoL6jwX+gtwzxUk=";
  };

  nativeBuildInputs = [
    dart-sass
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    echo "exports.compilerCommand = ['dart-sass'];" > \
      node_modules/.pnpm/sass-embedded@*/node_modules/sass-embedded/dist/lib/src/compiler-path.js

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gradient-frontend
    cp -r dist/gradient-frontend/browser/* $out/share/gradient-frontend/
    install -Dm444 dist/gradient-frontend/3rdpartylicenses.txt \
      $out/share/doc/gradient-frontend/3rdpartylicenses.txt

    runHook postInstall
  '';

  meta = {
    description = "Nix-CI for Teams (web frontend)";
    inherit (gradient.meta)
      homepage
      changelog
      license
      teams
      ;
    platforms = lib.platforms.unix;
  };
})
