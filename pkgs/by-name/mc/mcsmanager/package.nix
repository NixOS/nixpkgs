{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  jq,
  mcsmanager-zip-tools,
  mcsmanager-pty,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcsmanager";
  version = "10.6.1";

  # Can be removed after https://github.com/NixOS/nixpkgs/pull/416077
  nodejs = nodejs_24;

  src = fetchFromGitHub {
    owner = "MCSManager";
    repo = "MCSManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3QEemAeA4GxA1MFp2+A4rSYMSTjMf+oNB6U0InJiwBA=";
  };

  common = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-common";
    inherit (finalAttrs) version src nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/common";

    npmDepsHash = "sha256-rYwuD9lEMwcCFCAnozv8JxWN+8GmU+/j8fq3WqyBalo=";
  });

  frontend = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-+HmjkLtCa+MM51DTtxnubPkx/ALtO+FSQi13iZDy7sM=";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  });

  daemon = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-daemon";
    inherit (finalAttrs) version src nodejs;

    patches = [
      # Remove runtime chmod for modules like mcsmanager-pty and mcsmanager-zip-tools
      ./0001-Replace-hardcoded-PTY-and-zip-tools-paths-with-place.patch
      # Use a placeholder for the version to read it from package.json later
      ./0002-Replace-version-with-placeholder-in-daemon.patch
    ];

    postPatch = ''
      rm -rf common
      cp -r ${finalAttrs.common}/lib/node_modules/${finalAttrs.common.pname} common

      substituteInPlace daemon/src/const.ts \
        --replace-fail "@ptyPath@" "${lib.getExe mcsmanager-pty}" \
        --replace-fail "@zipToolsPath@" "${lib.getExe mcsmanager-zip-tools}"

      substituteInPlace daemon/src/service/version.ts \
        --replace-fail "@daemonVersion@" "$(${lib.getExe jq} -r .version < daemon/package.json)"

      cd daemon
    '';

    npmDepsHash = "sha256-j+HSnctPlqpfF/xumx4o2RgUA+T9OsqsuCtGatsc+ZE=";

    installPhase = ''
      runHook preInstall

      cp -r . $out

      runHook postInstall
    '';
  });

  panel = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-panel";
    inherit (finalAttrs) version src nodejs;

    # These patches are required because mcsm-web assumes it runs under the same directory as app.js
    patches = [
      # Use placeholders for the daemon and panel versions to read them from package.json later
      ./0003-Replace-versions-with-placeholders-in-panel.patch
      # Allow panel to correctly find the the path of frontend
      ./0004-Replace-static-path-with-placeholder-in-panel.patch
    ];

    postPatch = ''
      rm -rf common daemon
      cp -r ${finalAttrs.daemon} daemon
      cp -r ${finalAttrs.common}/lib/node_modules/${finalAttrs.common.pname} common

      substituteInPlace panel/src/app/version.ts \
        --replace-fail "@panelVersion@" "$(${lib.getExe jq} -r .version < panel/package.json)" \
        --replace-fail "@daemonVersion@" "$(${lib.getExe jq} -r .daemonVersion < panel/package.json)"

      substituteInPlace panel/src/app.ts \
        --replace-fail "@frontendDist@" "${finalAttrs.frontend}"

      cd panel
    '';

    npmDepsHash = "sha256-4HjfINaFBHm/NMK+986gDJLgxAxcBovifPMkWJTVDw4=";

    installPhase = ''
      runHook preInstall

      cp -r . $out

      runHook postInstall
    '';
  });

  nativeBuildInputs = [
    makeBinaryWrapper
    finalAttrs.nodejs
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{daemon,web}

    cp -r ${finalAttrs.daemon}/{production/app.js{,.map},node_modules,package{,-lock}.json} $out/share/daemon
    cp -r ${finalAttrs.panel}/{production/app.js{,.map},node_modules,package{,-lock}.json} $out/share/web

    for p in daemon web
    do
      pushd $out/share/$p
      chmod -R +w node_modules
      npm prune --omit=dev --no-save
      rm package{,-lock}.json
      popd
      makeWrapper ${lib.getExe finalAttrs.nodejs} $out/bin/mcsm-$p \
        --set NODE_PATH "$out/share/$p/node_modules" \
        --add-flags $out/share/$p/app.js
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    # The order of frontend, common, daemon, and panel must be preserved here.
    extraArgs = [
      "-s"
      "frontend"
      "-s"
      "common"
      "-s"
      "daemon"
      "-s"
      "panel"
    ];
  };

  meta = {
    description = "Free, Secure, Distributed, Modern Control Panel for Minecraft and most Steam Game Servers";
    homepage = "https://mcsmanager.com";
    changelog = "https://github.com/MCSManager/MCSManager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mcsm-daemon";
  };
})
