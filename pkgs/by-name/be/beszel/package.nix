{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:
let
  githubTag = "0.12.9";
  sourceHash = "sha256-uyNY8vvagIINEVFKzoGB4oxvOIYwIg80yso8UDc1e/w=";
  npmHash = "sha256-2zpJgkDXZoMWI6SkcfrhzozAITUR9ZUVtMbRtYKM13w=";
  goHash = "sha256-8Sr7MYQnIfNx9hvfjCTYKQOUZIBxpGPbsR75jEB0mbk=";
in
buildGoModule rec {
  pname = "beszel";
  version = githubTag;

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${version}";
    hash = sourceHash;
  };

  webui = buildNpmPackage {
    inherit
      pname
      version
      src
      meta
      ;

    npmFlags = [ "--legacy-peer-deps" ];

    buildPhase = ''
      runHook preBuild

      npx lingui extract --overwrite
      npx lingui compile
      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';

    sourceRoot = "${src.name}/internal/site";

    npmDepsHash = npmHash;
  };

  sourceRoot = "${src.name}";

  vendorHash = goHash;

  # TODO remove when #441125 is merged into master
  postPatch = ''substituteInPlace go.mod --replace "go 1.25.1" "go 1.25.0"'';

  preBuild = ''
    mkdir -p internal/site/dist
    cp -r ${webui}/* internal/site/dist
  '';

  postInstall = ''
    mv $out/bin/agent $out/bin/beszel-agent
    mv $out/bin/hub $out/bin/beszel-hub
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${version}";
    description = "Lightweight server monitoring hub with historical data, docker stats, and alerts";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
  };
}
