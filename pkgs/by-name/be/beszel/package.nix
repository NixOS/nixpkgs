{
  buildGo126Module,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  nixosTests,
}:
buildGo126Module (finalAttrs: {
  pname = "beszel";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CRO0Y3o3hwdE55D027fo0tvt9o7vsA1ooEBFlXuw2So=";
  };

  webui = buildNpmPackage {
    inherit (finalAttrs)
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

    sourceRoot = "${finalAttrs.src.name}/internal/site";

    npmDepsHash = "sha256-509/n5OH4z6LZH+jlmDLl2DlqKrD7M5ajtalmF/4n1o=";
  };

  vendorHash = "sha256-g+UmoxBoCL3oGXNTY67Wz7y6FC/nkcS8020jhTq4JQE=";

  tags = [ "testing" ];

  preBuild = ''
    mkdir -p internal/site/dist
    cp -r ${finalAttrs.webui}/* internal/site/dist
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCollectorStartHelpers/nvtop_collector"
        "TestApiRoutesAuthentication/GET_/update_-_shouldn't_exist_without_CHECK_UPDATES_env_var"
        "TestConfigSyncWithTokens"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mv $out/bin/agent $out/bin/beszel-agent
    mv $out/bin/hub $out/bin/beszel-hub
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "webui"
      ];
    };
    tests.nixos = nixosTests.beszel;
  };

  meta = {
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${finalAttrs.version}";
    description = "Lightweight server monitoring hub with historical data, docker stats, and alerts";
    maintainers = with lib.maintainers; [
      bot-wxt1221
      arunoruto
      BonusPlay
    ];
    license = lib.licenses.mit;
  };
})
