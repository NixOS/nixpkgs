{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  nodejs,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "degit";
  version = "3.9.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Rich-Harris";
    repo = "degit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IbFBAWD7Ci10BkZx5PcPOmg4Ur7Mm4YaRnqKvWILDlY=";
  };

  nativeBuildInputs = [
    bun
    makeWrapper
    nodejs
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/. .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/degit}
    cp -r assets degit dist node_modules package.json LICENSE.md $out/lib/degit/

    # NOTE:
    # We're silencing warnings because of DEP0169 in `degit`, which is present
    # both in the main project and its dependencies, namely `isomorphic-git`,
    # which in turn depends on `simple-get`, which uses the deprecated API.
    #
    # For now, let's just silence the warning so it doesn't annoy users.
    #
    # Also see:
    # - https://nodejs.org/api/deprecations.html#dep0169-insecure-urlparse
    # - https://nodejs.org/api/url.html#the-whatwg-url-api
    makeWrapper ${nodejs}/bin/node $out/bin/degit \
      --add-flags "--no-deprecation" \
      --add-flags "$out/lib/degit/degit"

    runHook postInstall
  '';

  passthru = {
    # Adapted from: pkgs/by-name/an/anytype/package.nix
    node_modules = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        # https://bun.com/docs/pm/cli/install#configuring-with-environment-variables

        # Bun always tries to use the fastest available installation method for the target platform. On macOS, that’s clonefile and on Linux, that’s hardlink.
        bun install \
          --backend=copyfile \
          --cpu="*" \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        runHook postInstall
      '';

      dontFixup = true;

      outputHash = "sha256-jUFea7eSY0AYtwPGUUXxoZQb6zZpmiaowqeVibck884=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
  };

  meta = {
    changelog = "https://github.com/Rich-Harris/degit/blob/${finalAttrs.src.rev}/docs/CHANGELOG.md";
    description = "Make copies of git repositories";
    homepage = "https://github.com/Rich-Harris/degit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kidonng ];
    mainProgram = "degit";
  };
})
