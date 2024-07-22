{
  lib,
  buildNpmPackage,
  nodejs_18,
  fetchFromGitHub,
}:

let
  # Overleaf contains git dependencies without package-lock.json
  gitDeps =
    lib.mapAttrs
      (
        repo: v:
        fetchFromGitHub {
          name = "overleaf-${repo}-source";
          owner = "overleaf";
          inherit repo;
          inherit (v) rev hash;
        }
      )
      {
        "diff-match-patch" = {
          rev = "89805f9c671a77a263fc53461acd62aa7498f688";
          hash = "sha256-MKqnBduRngD1z/s9Ya2sco3mxU7CoqUnxsdcj031tVU=";
        };
        "node-fast-crc32c" = {
          rev = "aae6b2a4c7a7a159395df9cc6c38dfde702d6f51";
          hash = "sha256-qLIhRZI1yDnJm1ss4ZRbcCdz7nk+rnc4EdGOIM32HfI=";
        };
        "socket.io-client" = {
          rev = "805a73d2a2e2408982597d5986a401088b7aa588";
          hash = "sha256-VNICbSXTcwtPVfQYH+jhp0TnJVGYyKn5NTziFUe94Vs=";
        };
        "socket.io" = {
          rev = "7ac322c2a5b26a4647834868d78afbb0db1f8849";
          hash = "sha256-nh6BU2p1iKEwmw3edS18k3YWgEvHMb4SE5U24Ey9rFA=";
        };
        "codemirror-autocomplete" = {
          rev = "dd201694c0ce7efa1777ef21d0dbe862dcefd338";
          hash = "sha256-PGstk5eax6rWFEK1QAZe2RLUCthdHhmL5SsBxGpqPrg=";
        };
        "codemirror-search" = {
          rev = "6a09ea7eaad138d810f989753036eabce23cc969";
          hash = "sha256-3hhZRkdUydvOMWY8sf5T1VM+zY8ME+PZ24ySU+gkldM=";
        };
        "codemirror-emacs" = {
          rev = "cea6eaefe2301bf07e7dec54f028537c3fdc4982";
          hash = "sha256-/fTan1DuKEDYVKD7jDIVpULTx7yNOdNscan0nh65k9U=";
        };
        "codemirror-indentation-markers" = {
          rev = "1b1f93c0bcd04293aea6986aa2275185b2c56803";
          hash = "sha256-MhAhGWsnMCvL56kFbJxeFzM+HsrgnDg4ClKBU2nicAA=";
        };
        "codemirror-vim" = {
          rev = "07f1b50f4b2e703792da75a29e9e1e479b6b7067";
          hash = "sha256-E7Inaod5VMK1x5dvi01qfpqiDzmw1vRivOYOjPqu57s=";
        };
        "ace-builds" = {
          rev = "80aa64e7098fead36c15a3f15c6cc6ca5f0e56b1";
          hash = "sha256-VsuKaJcmBPHYSgUFCNMAgen/kzcMBvJLTISN6spxALE=";
        };
        "daterangepicker" = {
          rev = "e496d2d44ca53e208c930e4cb4bcf29bcefa4550";
          hash = "sha256-avn774YhLIrziuF5NaNk1o2g9ItoxDaAzo11OmKEm5Y=";
        };
        "multer" = {
          rev = "e1df247fbf8e7590520d20ae3601eaef9f3d2e9e";
          hash = "sha256-izeFExOsqhOlslcOt3fmuZizzB9zSTT7B7vwkW8Mu7Y=";
        };
        "nodejs-referer-parser" = {
          rev = "8b8b103762d05b7be4cfa2f810e1d408be67d7bb";
          hash = "sha256-B8EeBIxZ3WNgW9jP52hB4pVnm3n3mTJ8hBwkGnZvPp0=";
        };
        "node-sandboxed-module" = {
          rev = "cafa2d60f17ce75cc023e6f296eb8de79d92d35d";
          hash = "sha256-l9juAnwe1Xe91cfFA+OJPWNo4FxdI+6T01jIeFm27W0=";
        };
      };

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
  version = "4.2";

  src = fetchFromGitHub {
    owner = "overleaf";
    repo = "overleaf";
    rev = "06a4989b4417f2fbc3d5d4d2e9fad7cea8863620";
    hash = "sha256-yfOTGDHqzwkzJD2xsRfW3yIz+obEDthh3nkQLd4Y7fI=";
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

  npmDepsHash = "sha256-2tdOYghca1UmTG1ZnpUUaZ2bmw0YgzwtKiA7V4DDeq8=";
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
