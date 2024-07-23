{
  lib,
  buildNpmPackage,
  nodejs_18,
  fetchFromGitHub,
  fetchgit,
}:

let
  # Overleaf contains git dependencies without package-lock.json
  gitDeps = lib.mapAttrs (_: v: fetchgit v) (builtins.fromJSON (builtins.readFile ./git-deps.json));

  patchGitDeps = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (repo: v: ''
      cp -r ${v} libraries/${repo}
      chmod -R +w libraries/${repo}
    '') gitDeps
  );

  # Move the prepare scripts to build time
  prepareGitDeps = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (repo: v: ''
      (
        cd libraries/${repo}
        ${
          lib.optionalString (
            repo != "codemirror-emacs"
          ) "[ -d node_modules ] && rm -r node_modules\n
        ln -s $node_modules node_modules"
        }
        if grep -q '"build":' package.json; then npm run build; fi
      )
    '') gitDeps
  );
in

(buildNpmPackage.override { nodejs = nodejs_18; }) {
  pname = "overleaf";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "overleaf";
    repo = "overleaf";
    rev = "a55d9fcf38755c6d982ddcbb0cd092b37d9879fa";
    hash = "sha256-SThESUyzQBbmiBTg7l/xpTvZ3chxXWAma5SRkjPhn04=";
  };

  # Patch all package.json to remove git dependencies
  prePatch =
    patchGitDeps
    + ''
      find . -name "package.json" -exec sed -i {} -e 's|"[github:]*overleaf\([^#]*\)#[^"]*|"file:../../libraries\1|' \;
      cp ${./package-lock.json} package-lock.json
      # npm ci fails due to git dependencies prepare scripts
      sed -i libraries/codemirror-{autocomplete,search}/package.json -e 's|"prepare":|"build":|'
      find libraries -name "package.json" -exec sed -i {} \
        -e 's|"prepare":|"noprepare":|' \
        -e 's|"build": "\(.*\.js\)"|"build": "${nodejs_18}/bin/node \1"|' \;
    '';

  # Fix ace-builds path due to git dependencies workaround
  patches = [ ./ace-builds.patch ];

  # Replace hard-coded values in settings by environment variables
  postPatch = ''
    find . -type f -not -path '*/\.*' -exec sed -E -i "s|SHARELATEX_|OVERLEAF_|g" {} +
    sed -i server-ce/config/settings.js \
      -e "s!mongodb://dockerhost/sharelatex!mongodb://localhost:27017/overleaf!" \
      -e "s!'dockerhost',!undefined,\n      path: process.env.OVERLEAF_REDIS_PATH || undefined,!" \
      -e "s!'6379'!undefined!" \
      -e "s!httpAuthUser = 'sharelatex'!httpAuthUser = process.env.WEB_API_USER!" \
      -e "s!'/var/lib/sharelatex\(.*\)'!\`\''${process.env.DATA_DIR}\1\`!" \
      -e "s!'http://localhost:3000'!\`http://\''${process.env.WEB_API_HOST || process.env.WEB_HOST || 'localhost'}:\''${process.env.WEB_API_PORT || process.env.WEB_PORT || 3000}\`!"
  '';

  npmDepsHash = "sha256-S1wLTeNlQwEpjiIcdviHhCNOL0X/gaApnFYoxZN75aU=";
  npmRebuildFlags = [ "--ignore-scripts" ]; # If these scripts passed it would simplify everything
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  preBuild =
    prepareGitDeps
    + ''
      npm run postinstall

      # Without this, bcrypt and diskusage are not built
      export CPPFLAGS="-I${nodejs_18}/include/node"
      (
        cd node_modules/bcrypt
        ${nodejs_18.pkgs.node-pre-gyp}/bin/node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs_18}/include/node
      )
      (
        cd node_modules/diskusage
        ${nodejs_18.pkgs.node-gyp}/bin/node-gyp configure --nodedir=${nodejs_18}/include/node
        ${nodejs_18.pkgs.node-gyp}/bin/node-gyp build --nodedir=${nodejs_18}/include/node
      )
    '';

  npmWorkspace = "services/web";
  npmBuildScript = "webpack:production";

  installPhase = ''
    mkdir -p $out/share
    cp -r {server-ce,services,libraries,node_modules} $out/share
  '';

  postFixup =
    lib.concatMapStringsSep "\n"
      (app: ''
        makeWrapper ${nodejs_18}/bin/node $out/bin/overleaf-${app} \
          --add-flags share/services/${app}/app.js \
          --chdir $out
      '')
      [
        "chat"
        "clsi"
        "contacts"
        "docstore"
        "document-updater"
        "filestore"
        "history-v1"
        "notifications"
        "project-history"
        "real-time"
        "spelling"
        "web"
      ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A web-based collaborative LaTeX editor";
    homepage = "https://github.com/overleaf/overleaf";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      camillemndn
      julienmalka
    ];
    mainProgram = "overleaf";
    platforms = platforms.unix;
  };
}
