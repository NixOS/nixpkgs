{ lib
, buildNpmPackage
, nodejs_18
, fetchFromGitHub
, python3
}:

let
  gitDeps = lib.mapAttrs (repo: v: fetchFromGitHub { name = "overleaf-${repo}-source"; owner = "overleaf"; inherit repo; inherit (v) rev hash; })
    {
      "diff-match-patch" = { rev = "89805f9c671a77a263fc53461acd62aa7498f688"; hash = "sha256-MKqnBduRngD1z/s9Ya2sco3mxU7CoqUnxsdcj031tVU="; };
      "node-fast-crc32c" = { rev = "aae6b2a4c7a7a159395df9cc6c38dfde702d6f51"; hash = "sha256-qLIhRZI1yDnJm1ss4ZRbcCdz7nk+rnc4EdGOIM32HfI="; };
      "socket.io-client" = { rev = "805a73d2a2e2408982597d5986a401088b7aa588"; hash = "sha256-VNICbSXTcwtPVfQYH+jhp0TnJVGYyKn5NTziFUe94Vs="; };
      "socket.io" = { rev = "7ac322c2a5b26a4647834868d78afbb0db1f8849"; hash = "sha256-nh6BU2p1iKEwmw3edS18k3YWgEvHMb4SE5U24Ey9rFA="; };
      "codemirror-autocomplete" = { rev = "dd201694c0ce7efa1777ef21d0dbe862dcefd338"; hash = "sha256-PGstk5eax6rWFEK1QAZe2RLUCthdHhmL5SsBxGpqPrg="; };
      "codemirror-search" = { rev = "6a09ea7eaad138d810f989753036eabce23cc969"; hash = "sha256-3hhZRkdUydvOMWY8sf5T1VM+zY8ME+PZ24ySU+gkldM="; };
      "codemirror-emacs" = { rev = "cea6eaefe2301bf07e7dec54f028537c3fdc4982"; hash = "sha256-/fTan1DuKEDYVKD7jDIVpULTx7yNOdNscan0nh65k9U="; };
      "codemirror-indentation-markers" = { rev = "1b1f93c0bcd04293aea6986aa2275185b2c56803"; hash = "sha256-MhAhGWsnMCvL56kFbJxeFzM+HsrgnDg4ClKBU2nicAA="; };
      "codemirror-vim" = { rev = "07f1b50f4b2e703792da75a29e9e1e479b6b7067"; hash = "sha256-E7Inaod5VMK1x5dvi01qfpqiDzmw1vRivOYOjPqu57s="; };
      "ace-builds" = { rev = "80aa64e7098fead36c15a3f15c6cc6ca5f0e56b1"; hash = "sha256-VsuKaJcmBPHYSgUFCNMAgen/kzcMBvJLTISN6spxALE="; };
      "daterangepicker" = { rev = "e496d2d44ca53e208c930e4cb4bcf29bcefa4550"; hash = "sha256-avn774YhLIrziuF5NaNk1o2g9ItoxDaAzo11OmKEm5Y="; };
      "multer" = { rev = "e1df247fbf8e7590520d20ae3601eaef9f3d2e9e"; hash = "sha256-izeFExOsqhOlslcOt3fmuZizzB9zSTT7B7vwkW8Mu7Y="; };
      "nodejs-referer-parser" = { rev = "8b8b103762d05b7be4cfa2f810e1d408be67d7bb"; hash = "sha256-B8EeBIxZ3WNgW9jP52hB4pVnm3n3mTJ8hBwkGnZvPp0="; };
      "node-sandboxed-module" = { rev = "cafa2d60f17ce75cc023e6f296eb8de79d92d35d"; hash = "sha256-l9juAnwe1Xe91cfFA+OJPWNo4FxdI+6T01jIeFm27W0="; };
    };

  patchGitDeps = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (repo: v: ''
      cp -r ${v} libraries/${repo}
      chmod -R +w libraries/${repo}
    '')
    gitDeps);
in

(buildNpmPackage.override { nodejs = nodejs_18; }) rec {
  pname = "overleaf";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "overleaf";
    repo = "overleaf";
    rev = "06a4989b4417f2fbc3d5d4d2e9fad7cea8863620";
    hash = "sha256-yfOTGDHqzwkzJD2xsRfW3yIz+obEDthh3nkQLd4Y7fI=";
  };

  # Fix ace-builds path due to git dependencies workaround
  patches = [ ./ace-builds.patch ];

  prePatch = patchGitDeps + ''
    # Patched package.json without git dependencies
    find . -name "package.json" -exec sed -i {} -e 's|"[github:]*overleaf\([^#]*\)#[^"]*|"file:../../libraries\1|' \;
    cp ${./package-lock.json} package-lock.json

    # Remove useless prepare scripts in git dependencies
    find libraries -name "package.json" -exec sed -i {} -e 's/"prepare": ".*"/"prepare": ""/' \;
  '';

  npmDepsHash = "sha256-2tdOYghca1UmTG1ZnpUUaZ2bmw0YgzwtKiA7V4DDeq8=";
  npmRebuildFlags = [ "--ignore-scripts" ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  npmWorkspace = "services/web";
  npmBuildScript = "webpack:production";
  nativeBuildInputs = [ nodejs_18 ];
  buildInputs = [ python3 ];

  preBuild = ''
    (
      # Without this, bcrypt is not built
      cd node_modules/bcrypt
      export CPPFLAGS="-I${nodejs_18}/include/node"
      ${nodejs_18.pkgs.node-pre-gyp}/bin/node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs_18}/include/node
    )
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r {server-ce,services,libraries,node_modules} $out/share
  '';

  postFixup = ''
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-chat \
      --add-flags start \
      --chdir $out/share/services/chat
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-clsi \
      --add-flags start \
      --chdir $out/share/services/clsi
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-contacts \
      --add-flags start \
      --chdir $out/share/services/contacts
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-docstore \
      --add-flags start \
      --chdir $out/share/services/docstore
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-document-updater \
      --add-flags start \
      --chdir $out/share/services/document-updater
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-filestore \
      --add-flags start \
      --chdir $out/share/services/filestore
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-git-bridge \
      --add-flags start \
      --chdir $out/share/services/git-bridge
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-history-v1 \
      --add-flags start \
      --chdir $out/share/services/history-v1
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-notifications \
      --add-flags start \
      --chdir $out/share/services/notifications
    makeWrapper ${nodejs_18}/bin/npm $out/bin/project-history \
      --add-flags start \
      --chdir $out/share/services/project-history
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-real-time \
      --add-flags start \
      --chdir $out/share/services/real-time
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-spelling \
      --add-flags start \
      --chdir $out/share/services/spelling
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-web \
      --add-flags start \
      --chdir $out/share/services/web
  '';

  meta = with lib; {
    description = "A web-based collaborative LaTeX editor";
    homepage = "https://github.com/overleaf/overleaf";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn julienmalka ];
    mainProgram = "overleaf";
    platforms = platforms.unix;
  };
}
