{
  pkgs,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  which,
  postgresql,
  srcOnly,
  fetchpatch,
  clojure,
  callPackage,
  symlinkJoin,
  runtimeShell,
}:

let
  sourceInfo = builtins.fromJSON (builtins.readFile ./generated/source.json);

  src-unpatched = fetchFromGitHub {
    owner = "compdemocracy";
    repo = "polis";
    rev = sourceInfo.rev;
    hash = "sha256:${sourceInfo.sha256}";
  };

  clojureVersion = lib.concatStringsSep "." (lib.take 3 (lib.splitVersion clojure.version));

  source = srcOnly {
    name = "polis-source-patched";
    src = src-unpatched;
    patches = [
      # https://github.com/compdemocracy/polis/issues/1383#issuecomment-2008006508
      (fetchpatch {
        url = "https://github.com/PDIS/polis2023/commit/3d165ca76d5142c4e279ee3ccd627473b511bccc.patch";
        hash = "sha256-50pphYxjwRdbFJIRzH9vTCx81Nk7JJO7lzX2sHrJyqs=";
      })
    ];
    postPatch = ''
      # Nixpkgs doesn't have the same clojure version
      substituteInPlace math/deps.edn --replace-fail \
        'org.clojure/clojure {:mvn/version "1.11.1"}' \
        'org.clojure/clojure {:mvn/version "${clojureVersion}"}' \

      # https://github.com/plumatic/plumbing/issues/137
      substituteInPlace math/deps.edn --replace-fail \
        'prismatic/plumbing {:mvn/version "0.6.0"}' \
        'io.github.plumatic/plumbing {:git/sha "424bc704f2db422de34269c139a5494314b3a43b"}'
    '';
  };

  version = "unstable-${sourceInfo.date}";

  client-admin = buildNpmPackage {
    pname = "polis-client-admin";
    inherit version;

    src = "${source}/client-admin";

    postInstall = ''
      cp -r build $out/lib/node_modules/polis-client-admin/
    '';

    npmDepsHash = "sha256-r4/nClR2DRz5O2tbJaeybg1hpYBWagGGn0OXvJUp2/g=";
    npmBuildScript = "build:prod";
  };

  client-participation = buildNpmPackage {
    pname = "polis-client-participation";
    inherit version;

    postPatch = ''
      rm package-lock.json
      ln -s ${./generated/client-participation-package-lock.json} package-lock.json
    '';

    src = "${source}/client-participation";

    postInstall = ''
      cp -r dist $out/lib/node_modules/polis-client-participation/
    '';

    npmDepsHash = "sha256-n94Kh9WSXUbQJSubqdLcHViZG0e5zs+Kh+SR9MVqMQc=";
    forceGitDeps = true;
    makeCacheWritable = true;
    npmBuildScript = "build:prod";
  };

  client-report = buildNpmPackage {
    pname = "polis-client-report";
    inherit version;

    src = "${source}/client-report";

    postInstall = ''
      cp -r dist $out/lib/node_modules/polis-report/
    '';

    npmDepsHash = "sha256-ZVwgoXt/FLsDjonabXBMe0vFm+V7/GvheUYujISVJhw=";
    npmBuildScript = "build:prod";
  };

  file-server = buildNpmPackage {
    pname = "polis-file-server";
    inherit version;

    src = "${source}/file-server";

    postInstall = ''
      mkdir -p $out/lib/node_modules/polisfileserver/build
      # Files from this are overridden by the below copies
      cp -r --no-preserve=mode ${client-admin}/lib/node_modules/polis-client-admin/build $out/lib/node_modules/polisfileserver
      cp -r ${client-participation}/lib/node_modules/polis-client-participation/dist/* $out/lib/node_modules/polisfileserver/build
      cp -r ${client-report}/lib/node_modules/polis-report/dist/* $out/lib/node_modules/polisfileserver/build

      mkdir -p $out/bin
      cat > $out/bin/polis-file-server <<EOF
      #!${runtimeShell}
      cd $out/lib/node_modules/polisfileserver
      # From https://github.com/compdemocracy/polis/blob/0500fec09e1607f731c3544511622910a35028ed/file-server/package.json#L7
      ${pkgs.nodejs}/bin/node --max_old_space_size=400 --gc_interval=100 app.js
      EOF
      chmod +x $out/bin/polis-file-server
    '';

    npmDepsHash = "sha256-1cQiGwKt45DpK6DmkqA+iQ3/DRG0IZiORIITpHDQNUs=";
    dontNpmBuild = true;
  };

  math =
    let
      homeDirectory = import ./generated/createHome.nix {
        inherit pkgs;
        mavenRepos = [
          "https://repo1.maven.org/maven2/"
          "https://repo.clojars.org/"
        ];
        lockfile = ./generated/deps.lock.json;
      };
    in
    pkgs.writeShellScriptBin "polis-math" ''
      set -euo pipefail
      cd ${source}/math

      # Needed so that it doesn't try to write into the immutable source directory
      # https://clojure.org/reference/clojure_cli#cache_dir
      export CLJ_CONFIG=$HOME/.config

      export HOME="${homeDirectory}"
      export JAVA_TOOL_OPTIONS="-Duser.home=${homeDirectory}"

      ${clojure}/bin/clojure -M:run full
    '';

  server = buildNpmPackage {
    pname = "polis-server";
    inherit version;

    src = "${source}/server";

    npmDepsHash = "sha256-LZOnl7kJ4yCHg0etVS8mGwNdn/95woctM6rswmWvMcA=";

    nativeBuildInputs = [
      which
      postgresql
    ];

    postInstall = ''
      cp -r dist $out/lib/node_modules/polis/

      mkdir -p $out/share/polis/migrations
      cp -r postgres/migrations/*.sql $out/share/polis/migrations

      mkdir -p $out/bin
      cat > $out/bin/polis-server <<EOF
      #!${runtimeShell}
      cd $out/lib/node_modules/polis/dist
      # From https://github.com/compdemocracy/polis/blob/0500fec09e1607f731c3544511622910a35028ed/server/package.json#L10
      ${pkgs.nodejs}/bin/node --max_old_space_size=400 --gc_interval=100 app.js
      EOF
      chmod +x $out/bin/polis-server
    '';
  };

in
symlinkJoin {
  name = "polis-${version}";
  paths = [
    file-server
    math
    server
  ];

  passthru.src = source;
  passthru.updateScript = ./update.sh;
  passthru._updateScriptUtils = callPackage ./updateScriptUtils.nix { inherit source; };
}
