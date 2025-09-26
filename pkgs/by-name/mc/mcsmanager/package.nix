{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  jq,
  mcsmanager-zip-tools,
  mcsmanager-pty,
  makeBinaryWrapper,
  removeReferencesTo,
  srcOnly,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcsmanager";
  version = "10.7.1";

  src = fetchFromGitHub {
    owner = "MCSManager";
    repo = "MCSManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R3OCQSmM7+AmTKccdgp6GrikMBA2uXv7fYusk//IhFU=";
  };

  common = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-common";
    inherit (finalAttrs) version src;
    inherit nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/common";

    npmDepsHash = "sha256-WRgnY0kSd+g+0LpEvBJsN3j1T6zgMq4sQCKMiIbAGOA=";
  });

  frontend = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;
    inherit nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-ViCJ7kwBxuWJiZB4690i/9kJUBhx/TrYkA+ap5MigSg=";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  });

  daemon = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-daemon";
    inherit (finalAttrs) version src;
    inherit nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/daemon";

    patches = [
      # Remove runtime chmod for modules like mcsmanager-pty and mcsmanager-zip-tools
      ./Replace-hardcoded-PTY-and-zip-tools-paths-with-placeholders.patch
      # Use a placeholder for the version to read it from package.json later
      ./Replace-version-with-placeholder-in-daemon.patch
    ];

    postPatch = ''
      chmod -R u+w ..
      rm -rf ../common
      cp -r ${finalAttrs.common}/lib/node_modules/mcsmanager-common ../common

      substituteInPlace src/const.ts \
        --replace-fail "@ptyPath@" "${lib.getExe mcsmanager-pty}" \
        --replace-fail "@zipToolsPath@" "${lib.getExe mcsmanager-zip-tools}"

      substituteInPlace src/service/version.ts \
        --replace-fail "@daemonVersion@" "$(${lib.getExe jq} -r .version < package.json)"
    '';

    npmDepsHash = "sha256-i7s+3ceo683rftrI3TPso5rh8xqmfx8Wq+e3JffYN+U=";

    installPhase = ''
      runHook preInstall

      cp -r . $out

      runHook postInstall
    '';
  });

  panel = buildNpmPackage (subFinalAttrs: {
    pname = "${finalAttrs.pname}-panel";
    inherit (finalAttrs) version src;
    inherit nodejs;

    sourceRoot = "${subFinalAttrs.src.name}/panel";

    # These patches are required because mcsm-web assumes it runs under the same directory as app.js
    patches = [
      # Use placeholders for the daemon and panel versions to read them from package.json later
      ./Replace-versions-with-placeholders-in-panel.patch
      # Allow panel to correctly find the the path of frontend
      ./Replace-static-path-with-placeholder-in-panel.patch
    ];

    postPatch = ''
      chmod -R u+w ..
      rm -rf ../{common,daemon}
      cp -r ${finalAttrs.daemon} ../daemon
      cp -r ${finalAttrs.common}/lib/node_modules/mcsmanager-common ../common

      substituteInPlace src/app/version.ts \
        --replace-fail "@panelVersion@" "$(${lib.getExe jq} -r .version < package.json)" \
        --replace-fail "@daemonVersion@" "$(${lib.getExe jq} -r .daemonVersion < package.json)"

      substituteInPlace src/app.ts \
        --replace-fail "@frontendDist@" "${finalAttrs.frontend}"
    '';

    npmDepsHash = "sha256-zdryoufbxt8r0L0nFG5Y3NG1AzOjf16/4KDDv5R+y1U=";

    installPhase = ''
      runHook preInstall

      cp -r . $out

      runHook postInstall
    '';
  });

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    removeReferencesTo
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Glob will match all subdirs.
    shopt -s globstar

    mkdir -p $out/share/{daemon,web}

    cp -r ${finalAttrs.daemon}/{production/app.js{,.map},node_modules,package{,-lock}.json} $out/share/daemon
    cp -r ${finalAttrs.panel}/{production/app.js{,.map},node_modules,package{,-lock}.json} $out/share/web

    for p in daemon web; do
      # Prune
      pushd $out/share/$p
        chmod -R +w node_modules
        npm prune --omit=dev --no-save
        # Remove build artifacts that bloat the closure
        rm -rf \
          package{,-lock}.json \
          node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}
        find node_modules -type f -exec remove-references-to -t "${srcOnly nodejs}" {} \;
      popd

      makeWrapper ${lib.getExe nodejs} $out/bin/mcsm-$p \
        --set NODE_PATH "$out/share/$p/node_modules" \
        --add-flags $out/share/$p/app.js
    done

    shopt -u globstar

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
    changelog = "https://github.com/MCSManager/MCSManager/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mcsm-daemon";
  };
})
