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
  version = "1.5.5";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "matter-js";
    repo = "matterjs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A5TjsRVtIXzaFOYzy1kR0Rbdh41HqXmayM17Dg1c8eA=";
  };

  npmDepsHash = "sha256-zlVdqIiz0uo+n0iIBsH82nrRmH9nd51fwwUp5vn9bDA=";

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  buildInputs = [ udev ];

  env = {
    CXXFLAGS = "-std=c++20";
    PUPPETEER_SKIP_DOWNLOAD = "1";
  };

  preBuild = "npm run version -- --apply";

  # remove temporary build files
  postBuild = ''
    shopt -s globstar
    rm node_modules/**/build/{config.gypi,Makefile,*.target.mk}
    shopt -u globstar
  '';

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
