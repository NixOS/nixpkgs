{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildNpmPackage,
  nodejs,
  npmHooks,
  nixosTests,
}:

buildNpmPackage (finalAttrs: {
  pname = "scanservjs";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "sbs20";
    repo = "scanservjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UyNSEjwqL+DHTJWgJ6lrNXfPuNJv2H3rUtpRqdNeEkg=";
  };

  appServerNpmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-app-server-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/app-server";
    hash = "sha256-zp8gguoc+OdSABCOKUzLMuKIrnuYVX39kCD8b7ZTIgQ=";
  };

  appUiNpmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-app-ui-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/app-ui";
    hash = "sha256-/30JnlN66N3pWQHHxeGG6k0nW3miFfiYlb3Snx2BP6E=";
  };

  npmDepsHash = "sha256-BNYRDVGC7wFdv7VKARZee2ea1QcLSX3iwoCGGcsVtag=";

  patches = [
    ./nix-compatibility.patch
  ];

  nativeBuildInputs = [
    npmHooks.npmConfigHook
  ];

  preConfigure = ''
    npmRoot=app-server npmDeps=${finalAttrs.appServerNpmDeps} npmConfigHook
    npmRoot=app-ui npmDeps=${finalAttrs.appUiNpmDeps} npmConfigHook
  '';

  postBuild = ''
    # Install runtime dependencies
    npm_config_cache=${finalAttrs.appServerNpmDeps} npm install \
      --prefix ./dist \
      --offline \
      --production \
      --ignore-scripts
  '';

  installPhase = ''
    runHook preInstall

    rm -rf $out/lib

    mkdir -p $out/lib
    cp -r dist/* $out/lib

    substituteInPlace "$out/lib/server/express-configurer.js" \
      --replace-fail "@client@" "$out/lib/client"

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/scanservjs \
      --set NODE_ENV production \
      --add-flags "$out/lib/server/server.js"

    runHook postInstall
  '';

  passthru = {
    tests.smoke-test = nixosTests.scanservjs;
  };

  meta = {
    description = "SANE scanner nodejs web ui";
    longDescription = "scanservjs is a simple web-based UI for SANE which allows you to share a scanner on a network without the need for drivers or complicated installation.";
    homepage = "https://github.com/sbs20/scanservjs";
    license = lib.licenses.gpl2Only;
    mainProgram = "scanservjs";
    maintainers = with lib.maintainers; [ chayleaf ];
    platforms = lib.platforms.linux;
  };
})
