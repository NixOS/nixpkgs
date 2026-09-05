{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  stdenvNoCC,
}:

let
  versionData = lib.importJSON ./hashes.json;
  inherit (versionData)
    version
    hash
    vendorHash
    pnpmDepsHash
    ;
in
buildGo127Module (finalAttrs: {
  pname = "sub2api";
  inherit version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Wei-Shaw";
    repo = "sub2api";
    tag = "v${finalAttrs.version}";
    inherit hash;
  };

  modRoot = "backend";
  subPackages = [ "cmd/server" ];
  inherit vendorHash;

  frontend = stdenvNoCC.mkDerivation (frontendAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${frontendAttrs.src.name}/frontend";

    pnpmDeps = fetchPnpmDeps {
      inherit (frontendAttrs)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = pnpmDepsHash;
    };

    nativeBuildInputs = [
      nodejs_24
      pnpmConfigHook
      pnpm_10
    ];

    buildPhase = ''
      runHook preBuild
      pnpm exec vue-tsc -b
      pnpm exec vite build --outDir "$TMPDIR/dist"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r "$TMPDIR/dist" $out
      runHook postInstall
    '';
  });

  tags = [ "embed" ];
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.BuildType=release"
  ];

  preBuild = ''
    cp -r ${finalAttrs.frontend} internal/web/dist
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/server $out/bin/sub2api

    mkdir -p $out/share/sub2api
    cp -r resources $out/share/sub2api/

    wrapProgram $out/bin/sub2api \
      --set-default PRICING_FALLBACK_FILE \
        "$out/share/sub2api/resources/model-pricing/model_prices_and_context_window.json"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "AI API gateway platform for distributing and managing AI subscription API quotas";
    homepage = "https://github.com/Wei-Shaw/sub2api";
    changelog = "https://github.com/Wei-Shaw/sub2api/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "sub2api";
    maintainers = with lib.maintainers; [ _27Aaron ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
