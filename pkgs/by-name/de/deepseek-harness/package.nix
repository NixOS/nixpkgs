{
  lib,
  stdenv,
  curl,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nodejs_24,
  pnpm_11,
  pnpmBuildHook,
  pnpmConfigHook,
  runCommand,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deepseek-harness";
  version = "0.2.0-rc.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    tag = "dsh-v${finalAttrs.version}";
    hash = "sha256-8r1HngwiAK6cjH5f70tBXsIx1wce2f3wp3VeYvq6/o0=";

    # Capture the commit hash at fetch time to avoid git build dependency
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > .git-commit
      rm -rf .git
    '';
  };

  # internalModules() calls node-addon-require-builtin unconditionally, but
  # its binary scan does not recognize toolchain-built Node
  # (Unsupported/no-getter), breaking every `dsh --profile …` boot. Prefer a
  # plain require under --expose-internals (which the wrapper below passes).
  patches = [
    ./expose-internals-profile-resolution.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-+7jFaROKpN8XHFpulloK2lb0GsYXbEdMs/V7ZO9leKE=";
  };

  nativeBuildInputs = [
    nodejs_24
    pnpmConfigHook
    pnpmBuildHook
    pnpm_11
    makeBinaryWrapper
  ];

  preBuild = ''
    export DSH_CLIENT_COMMIT_HASH=$(cat $src/.git-commit)
    export DSH_CLIENT_BUILD_PROFILE="official";
  '';

  # The root 'build' script runs both 'build:lib' and 'build:web'
  # pnpmBuildHook runs 'pnpm run build' by default
  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/dsh
    cp -r . $out/libexec/dsh/

    # The .git-commit marker only feeds the build-time commit stamp.
    rm -f $out/libexec/dsh/.git-commit

    # Drop dangling symlinks from optional cross-platform packages.
    find $out/libexec/dsh/node_modules/.pnpm -type l ! -exec test -e {} \; -delete

    # Mirror workspace packages to the root node_modules so the loader's bare import() resolves.
    shopt -s nullglob
    store_scopes=("$out/libexec/dsh/node_modules/.pnpm/node_modules/"@*/)
    for scope in "''${store_scopes[@]}"; do
      scope_name=$(basename "$scope")
      mkdir -p "$out/libexec/dsh/node_modules/$scope_name"
      for pkg in "$scope"*; do
        # -n: do not dereference an existing symlink-to-dir
        ln -sfn "../.pnpm/node_modules/$scope_name/$(basename "$pkg")" \
          "$out/libexec/dsh/node_modules/$scope_name/$(basename "$pkg")"
      done
    done

    # --expose-internals is required by the HMR service and the loader's internal module loader
    makeBinaryWrapper ${nodejs_24}/bin/node $out/bin/dsh \
      --prefix PATH : ${lib.makeBinPath [ pnpm_11 ]} \
      --add-flags "--expose-internals $out/libexec/dsh/apps/cli/lib/bin.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$TMPDIR
    $out/bin/dsh --version
  '';

  passthru = {
    updateScript = nix-update-script {
      # TODO: Drop after 1.0
      extraArgs = [
        "--version"
        "unstable"
      ];
    };
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      web-boot =
        runCommand "deepseek-harness-web-boot"
          {
            nativeBuildInputs = [
              curl
              finalAttrs.finalPackage
            ];
          }
          ''
            export HOME=$TMPDIR
            dsh --profile web --no-open >server.log 2>&1 &
            pid=$!
            trap 'kill $pid 2>/dev/null || true' EXIT
            for i in $(seq 1 30); do
              if launch_url=$(grep -o 'http://127.0.0.1:3080/?token=[^[:space:]]*' server.log); then
                break
              fi
              sleep 1
            done
            curl --fail --silent "''${launch_url:-}" | grep -q '<!doctype html>'
            touch $out
          '';
    };
  };

  meta = {
    description = "AI agent harness with a plugin-based architecture";
    longDescription = ''
      DeepSeek Harness (dsh) is a self-hosted AI agent harness built around a
      plugin architecture — "Everything is a Plugin". It ships a CLI and a web
      UI and is extended through workspace plugins.
    '';
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      Dietr1ch
      tlvince
    ];
  };
})
