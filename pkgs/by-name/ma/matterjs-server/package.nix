{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  udev,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage (finalAttrs: {
  pname = "matterjs-server";
  version = "1.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "matter-js";
    repo = "matterjs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LNSj9y+FDCsz4xiP8pL4xs7TVg2Cl5FOtWLTclewVbU=";
  };

  npmDepsHash = "sha256-bvmh6Jv0KDOZOY7Ti0TgbSdVcyYHhX0YOY/8PB7pebs=";

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  buildInputs = [ udev ];

  env.CXXFLAGS = "-std=c++20";

  preBuild = "npm run version -- --apply";

  dontNpmInstall = true;

  makeWrapperArgs = [
    "--set"
    "NODE_OPTIONS"
    "--enable-source-maps"
  ];

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-save

    mkdir -p $out/lib/matterjs-server
    cp -r node_modules packages $out/lib/matterjs-server/

    makeWrapper ${lib.getExe nodejs} $out/bin/matterjs-server \
      --add-flags "$out/lib/matterjs-server/packages/matter-server/dist/esm/MatterServer.js" \
      "''${makeWrapperArgs[@]}"

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    tests = { inherit (nixosTests) matterjs-server; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Matter server based on Matter.js";
    homepage = "https://github.com/matter-js/matterjs-server";
    changelog = "https://github.com/matter-js/matterjs-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kranzes
      marie
    ];
    mainProgram = "matterjs-server";
    platforms = lib.platforms.linux;
  };
})
