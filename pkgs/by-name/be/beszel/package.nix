{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  nixosTests,
}:
buildGoModule rec {
  pname = "beszel";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${version}";
    hash = "sha256-/rFVH3kWf9OB3/iJNOARG85y1WH03hW8LvsIRzq1vnU=";
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

    npmDepsHash = "sha256-509/n5OH4z6LZH+jlmDLl2DlqKrD7M5ajtalmF/4n1o=";
  };

  vendorHash = "sha256-O5gFpQ90AQFSAidPTWPrODZ4LWuwrOMpzEH/8HrjBig=";

  preBuild = ''
    mkdir -p internal/site/dist
    cp -r ${webui}/* internal/site/dist
  '';

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
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${version}";
    description = "Lightweight server monitoring hub with historical data, docker stats, and alerts";
    maintainers = with lib.maintainers; [
      bot-wxt1221
      arunoruto
      BonusPlay
    ];
    license = lib.licenses.mit;
  };
}
