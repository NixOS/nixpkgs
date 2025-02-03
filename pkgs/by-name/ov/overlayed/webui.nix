{
  src,
  meta,
  version,
  stdenv,
  nodejs,
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit version src meta;
  pname = "overlayed-webui";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-FBJrVXTgKh8Op7TiZjA/i2LY2OOIKmqGR+GwGUecqVI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild

    cd apps/desktop
    node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
