{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  stdenv,
  runtimeShell,
  nixosTests,
}:

let
  version = "4.27.1";

  src = fetchFromGitHub {
    owner = "casdoor";
    repo = "casdoor";
    tag = "v${version}";
    hash = "sha256-OPzMWgCOaXTu1YC7DAXmEy3p6Xd/EZxWZIv/v+CliNE=";
  };

  # The web console is a separate React/Vite application in web/. It has to be
  # built before the Go binary can serve it, and the Go binary serves it from
  # disk relative to its working directory (see routers/static_filter.go).
  #
  # Some of its settings live in "web/src/Conf.ts" and are compiled into the
  # bundle, so they can only be changed before "yarn build" runs. The
  # derivation is therefore a function of them, and the main package exposes
  # them as overridable attributes, which the NixOS module sets through
  # "overrideAttrs".
  frontend =
    {
      customFooter ? "",
      showCloudPromotion ? true,
    }:
    stdenv.mkDerivation {
      pname = "casdoor-frontend";
      inherit version;

      src = src + "/web";

      offlineCache = fetchYarnDeps {
        yarnLock = "${src}/web/yarn.lock";
        hash = "sha256-XEu/svKG4XP4cxMhuIJtmA4QECm28FKbM1dda9+PLcY=";
      };

      nativeBuildInputs = [
        nodejs
        yarnConfigHook
        yarnBuildHook
      ];

      # Cypress is a dev dependency that downloads a ~200MB browser bundle on
      # install. It is only needed for the e2e tests, which we do not run.
      CYPRESS_INSTALL_BINARY = "0";

      # The footer shown instead of the "Powered by Casdoor" line. It is an
      # HTML fragment, so it can contain markup. An empty string keeps the
      # upstream default. It is passed through the environment, so that quotes
      # and dollar signs in the markup do not break the shell.
      inherit customFooter;

      # Whether the console advertises the hosted Casdoor Cloud offering. The
      # backend can override this at runtime through the "jsonWebConfig" cookie,
      # so this only sets the default that is used until the backend answers.
      inherit showCloudPromotion;

      patchPhase = ''
        runHook prePatch

        if [ -n "$customFooter" ]; then
          # "CustomFooter" is rendered as a React node, but "Conf.ts" is a plain
          # TypeScript file and cannot contain JSX. The footer is therefore
          # built with "React.createElement" from the HTML fragment. The
          # upstream default is "null", which keeps the built-in footer.
          substituteInPlace src/Conf.ts \
            --replace-fail "export const CustomFooter = null;" \
            "export const CustomFooter = React.createElement(\"div\", { dangerouslySetInnerHTML: { __html: \`$customFooter\` } });"

          # The React import is only needed for the custom footer. It is
          # appended, because "import" declarations are hoisted and may appear
          # anywhere in the file.
          if ! grep -q "from \"react\"" src/Conf.ts; then
            printf '\nimport * as React from "react";\n' >> src/Conf.ts
          fi
        fi

        # "ShowCloudPromotion" only exists in newer upstream releases. Adding it
        # here keeps the setting working when the package is updated, and is a
        # no-op for releases that do not have it yet.
        if grep -q "ShowCloudPromotion" src/Conf.ts; then
          substituteInPlace src/Conf.ts \
            --replace-fail "export let ShowCloudPromotion = true;" \
            "export let ShowCloudPromotion = ${lib.boolToString showCloudPromotion};"
        else
          printf '\nexport let ShowCloudPromotion = %s;\n' "${lib.boolToString showCloudPromotion}" \
            >> src/Conf.ts
        fi

        runHook postPatch
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        # "yarn build" runs "vite build" (outDir: build-temp) and then "postbuild"
        # (node mv.js), which renames build-temp to build.
        cp -r build $out/build

        runHook postInstall
      '';

      doCheck = false;

      meta = {
        description = "Casdoor web console frontend";
        license = lib.licenses.asl20;
        platforms = lib.platforms.unix;
      };
    };
in
buildGoModule (finalAttrs: {
  pname = "casdoor";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-rMB3lAdjqpfjHyWMZj6RrnuVvvMpT47V40isZu6KH3E=";

  # Upstream tests need a running database server and network access, neither
  # of which is available in the build sandbox.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/casdoor/casdoor/util.Version=${finalAttrs.version}"
    "-X github.com/casdoor/casdoor/util.CommitId=${finalAttrs.src.rev}"
  ];

  # All database drivers Casdoor uses, including the SQLite one, are pure Go,
  # so the binary links statically. Upstream's own build.sh and Dockerfile do
  # the same.
  env.CGO_ENABLED = 0;

  # A statically linked binary has no dynamic section, so there is no RPATH for
  # patchelf to shrink. Skipping the hook keeps the build log free of
  # "cannot find section '.dynamic'" errors.
  dontPatchELF = true;

  # The footer of the web console, shown instead of the "Powered by Casdoor"
  # line. It is a snippet of HTML, so it can contain markup. An empty string
  # keeps the upstream default.
  customFooter = "";

  # Whether the web console advertises the hosted Casdoor Cloud offering. The
  # backend can override this at runtime through the "jsonWebConfig" cookie,
  # so this only sets the default that is used until the backend answers.
  showCloudPromotion = true;

  # The web console is served from disk relative to the working directory, so it
  # has to be in place before the binary is linked.
  preBuild = ''
    cp -r ${
      frontend {
        inherit (finalAttrs) customFooter showCloudPromotion;
      }
    }/build ./web/build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r "$GOPATH/bin" $out

    mkdir -p $out/share/casdoor/web
    cp -r ./web/build $out/share/casdoor/web/build
    cp -r ./swagger $out/share/casdoor/swagger
    # The upstream "conf" directory is a Go source package. Only the sample
    # configuration file is read at runtime, the WAF configuration is embedded
    # into the binary.
    mkdir -p $out/share/casdoor/conf
    cp ./conf/app.conf $out/share/casdoor/conf/app.conf
    cp -r ./init_data.json.template $out/share/casdoor/init_data.json.template

    # The upstream sample configuration points at a MySQL server on localhost
    # and enables the development mode. SQLite needs no server at all, so make
    # that the default.
    substituteInPlace $out/share/casdoor/conf/app.conf \
      --replace-fail "driverName = mysql" "driverName = sqlite" \
      --replace-fail 'dataSourceName = root:123456@tcp(localhost:3306)/' "dataSourceName = casdoor.db" \
      --replace-fail "runmode = dev" "runmode = prod" \
      --replace-fail 'frontendBaseDir = "../cc_0"' ""

    # Casdoor resolves the frontend ("web/build"), the Swagger UI ("swagger")
    # and its own configuration ("conf/app.conf") relative to the working
    # directory, and it writes to "logs/", "files/" and "tmp/" there as well.
    # The store is read-only, so the wrapper assembles a writable runtime
    # directory that symlinks the read-only parts back into the store.
    mv $out/bin/casdoor $out/bin/.casdoor-unwrapped
    cat > $out/bin/casdoor <<EOF
    #!${runtimeShell}
    set -euo pipefail

    runtimeDir="\''${CASDOOR_RUNTIME_DIR:-\''${XDG_STATE_HOME:-\''${HOME}/.local/state}/casdoor}"
    export CASDOOR_RUNTIME_DIR="\$runtimeDir"

    mkdir -p "\$runtimeDir"

    for d in conf web swagger; do
      # Refresh symlinks so an upgraded package does not keep serving the
      # previous store path. A dangling symlink (for example after garbage
      # collection) must be replaced as well.
      if [ -L "\$runtimeDir/\$d" ] || [ ! -e "\$runtimeDir/\$d" ]; then
        ln -sfn "$out/share/casdoor/\$d" "\$runtimeDir/\$d"
      fi
    done

    cd "\$runtimeDir"

    exec "$out/bin/.casdoor-unwrapped" "\$@"
    EOF
    chmod +x $out/bin/casdoor

    runHook postInstall
  '';

  passthru = {
    frontend = frontend {
      inherit (finalAttrs) customFooter showCloudPromotion;
    };
    tests = {
      nixos = nixosTests.casdoor;
    };
  };

  meta = {
    description = "An open-source, self-hosted identity and access management platform";
    homepage = "https://casdoor.org";
    changelog = "https://github.com/casdoor/casdoor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "casdoor";
    maintainers = with lib.maintainers; [ ser ];
    platforms = lib.platforms.unix;
  };
})
