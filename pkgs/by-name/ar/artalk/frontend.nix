{
  stdenvNoCC,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,

  artalk,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${artalk.pname}-frontend";

  inherit (artalk) src version;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-RSz/bx8/BAqLZH3/yQ6/H/nnwGvcCg8EzIEJ4/xkQgQ=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build:all
    pnpm build:auth

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{dist/{i18n,plugins},sidebar}

    # dist
    cp ./ui/artalk/dist/{Artalk,ArtalkLite}.{css,js} $out/dist
    cp ./ui/artalk/dist/i18n/*.js $out/dist/i18n
    cp ./ui/plugin-*/dist/*.js $out/dist/plugins

    # sidebar
    cp -r ./ui/artalk-sidebar/dist/* $out/sidebar

    runHook postInstall
  '';
})
