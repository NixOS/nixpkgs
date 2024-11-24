{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  fetchpatch,
}:

buildGoModule rec {
  pname = "beszel";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    rev = "refs/tags/v${version}";
    hash = "sha256-x9HU+sDjxRthC4ROJaKbuKHPHgxFSpyn/dywyGWE/v8=";
  };

  webui = buildNpmPackage {
    inherit
      pname
      version
      src
      meta
      ;

    npmFlags = [ "--legacy-peer-deps" ];

    patches = [
      # add missing @esbuild for multi platform
      # https://github.com/henrygd/beszel/pull/235
      # add missing @esbuild for multi platform
      # https://github.com/henrygd/beszel/pull/235
      ./0001-fix-build.patch
    ];

    buildPhase = ''
      runHook preBuild

      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';

    sourceRoot = "${src.name}/beszel/site";

    npmDepsHash = "sha256-t7Qcuvqbt0sPHAu3vcZaU8/Ij2yY5/g1TguozlKu0mU=";
  };

  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-/FePQkqoeuH63mV81v1NxpFw9osMUCcZ1bP+0yN1Qlo=";

  preBuild = ''
    mkdir -p site/dist
    cp -r ${webui}/* site/dist
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
