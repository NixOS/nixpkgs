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
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deepseek-harness";
  version = "0.1.5-rc.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    rev = "dsh-v${finalAttrs.version}";
    hash = "sha256-UqzUag5ux278+tur2GvUsc/Ml7OioU8jcG+kilJp6Mo=";

    # Capture the commit hash at fetch time to avoid git build dependency
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > .git-commit
      rm -rf .git
    '';
  };

  # pnpm resolves platform-conditioned optional dependencies per host
  # platform, so the store contents differ between x86_64-linux and
  # aarch64-linux (the optional native deps) and so does the hash.
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash =
      if stdenv.hostPlatform.isAarch64 then
        "sha256-/VnxXqJ3MUXIPB4rXOKu5FtArYVjyEry4ptRNHxYnrc="
      else
        "sha256-9/sSWKnsgS9Owl+TDTqzz+VjFlYo3hOWhaDJ4ReYUMA=";
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
    # Avoid client window title defaulting to "DSH Local Build";
    export DSH_CLIENT_TITLE="DeepSeek Harness"
  '';

  # The root 'build' script runs both 'build:lib' and 'build:web'
  # pnpmBuildHook runs 'pnpm run build' by default
  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/dsh
    cp -r . $out/libexec/dsh/

    # The .git-commit marker only feeds the build-time commit stamp.
    rm -f $out/libexec/dsh/.git-commit

    # The whole tree is shipped because workspace packages resolve in-tree via
    # linkWorkspacePackages; dev/test/doc files come along for the ride.

    # Optional cross-platform binary packages leave dangling symlinks in
    # node_modules/.pnpm; drop them so the fixup phase passes.
    find $out/libexec/dsh/node_modules/.pnpm -type l ! -exec test -e {} \; -delete

    # pnpm only links workspace packages into each dependent package's own
    # node_modules, so the loader's bare `import(name)` (vendor/loader) cannot
    # resolve workspace specifiers from its own directory. Mirror the virtual
    # store's scoped packages into the root node_modules so bare specifiers
    # resolve anywhere in the tree. This relies on `linkWorkspacePackages: true`
    # in upstream's pnpm-workspace.yaml, which is what places workspace
    # packages under .pnpm/node_modules at all.
    shopt -s nullglob
    store_scopes=("$out/libexec/dsh/node_modules/.pnpm/node_modules/"@*/)
    for scope in "''${store_scopes[@]}"; do
      scope_name=$(basename "$scope")
      mkdir -p "$out/libexec/dsh/node_modules/$scope_name"
      for pkg in "$scope"*; do
        # -n: do not dereference an existing symlink-to-dir (e.g. the root
        # devDep dsh-tool-session-query) when replacing it.
        ln -sfn "../.pnpm/node_modules/$scope_name/$(basename "$pkg")" \
          "$out/libexec/dsh/node_modules/$scope_name/$(basename "$pkg")"
      done
    done

    # --expose-internals is required by the HMR service and the loader's
    # internal module loader; it must precede the script path so it lands in
    # process.execArgv. Depends on Node internals, not a stable API.
    makeBinaryWrapper ${nodejs_24}/bin/node $out/bin/dsh \
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

      # Boots the web profile and verifies the server actually serves. Guards the
      # fragile parts: the loader's bare import() of workspace specifiers and the
      # --expose-internals requirement. Since 0.1.2, the index requires a
      # one-time launch token: the boot log prints the authenticated URL whose
      # token mints a session cookie; exchange it and load the index with that
      # cookie.
      web-boot = runCommand "deepseek-harness-web-boot" { nativeBuildInputs = [ curl ]; } ''
        export HOME=$TMPDIR
        ${finalAttrs.finalPackage}/bin/dsh --profile web --no-open >server.log 2>&1 &
        pid=$!
        trap 'kill $pid 2>/dev/null || true' EXIT

        for i in $(seq 1 60); do
          if launch_url=$(grep -o 'http://127.0.0.1:3080/?token=[^[:space:]]*' server.log); then
            break
          fi
          sleep 1
        done
        if [ -z "''${launch_url:-}" ]; then
          echo "dsh web profile failed to print the authenticated launch URL" >&2
          cat server.log >&2
          exit 1
        fi

        # Mint the session cookie, then load the index through the redirect.
        if ! curl -fsSL -c cookies.txt "$launch_url" >page.html 2>curl.log \
          || ! grep -q '<!doctype html>' page.html; then
          echo "dsh web profile failed to serve the index via the launch token" >&2
          cat curl.log server.log >&2
          exit 1
        fi
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
    maintainers = with lib.maintainers; [ Dietr1ch ];
  };
})
