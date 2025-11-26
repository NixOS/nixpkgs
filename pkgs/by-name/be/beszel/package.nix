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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${version}";
    hash = "sha256-fPVjJfMaTSPolB6l2t1b2CjSaX3Gc4/0Nruy4OY9RAc=";
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

    npmDepsHash = "sha256-YVYHNAf0JdTpqUYq5JosuzWLOsZkbX2okNPj5JQTOto=";
  };

  vendorHash = "sha256-fXiCddu7DE6NLNJkYupQsAK0xMBoL0K5T7Ig0IuIbD4=";

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
