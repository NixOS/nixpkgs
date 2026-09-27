{
  lib,
  fetchFromGitHub,
  crystal,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellScript,
  crystal2nix,
  runCommand,
}:

crystal.buildCrystalPackage rec {
  pname = "ameba-ls";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba-ls";
    tag = "v${version}";
    hash = "sha256-0HIs+KpsiIDDh9pqg1bDLAcvCV2M7S5TJGtLycNxndI=";
  };

  shardsFile = ./shards.nix;

  crystalBinaries.ameba-ls.src = "src/ameba-ls.cr";

  buildTargets = [
    "ameba-ls"
  ];

  # There are no actual tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm555 bin/ameba-ls -t "$out/bin/"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/ameba-ls";

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--use-github-releases"
          "--src-only"
        ];
      })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "ameba-ls.shardLock" "${toString ./.}/shard.lock")
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          (writeShellScript "update-lock" "cd $1; ${lib.getExe crystal2nix}")
          ./.
        ];
      }
      {
        command = [
          "rm"
          "${toString ./.}/shard.lock"
        ];
      }
    ];
    shardLock = runCommand "shard.lock" { inherit src; } ''
      cp "$src/shard.lock" "$out"
    '';
  };

  meta = {
    description = "Crystal language server powered by Ameba linter";
    homepage = "https://github.com/crystal-ameba/ameba-ls";
    changelog = "https://github.com/crystal-ameba/ameba-ls/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "ameba-ls";
  };
}
