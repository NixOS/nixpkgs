{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  pnpm = pnpm_11;

  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "gitlens-${finalAttrs.version}.vsix";
    pname = "gitlens-vsix";
    version = "19.6.0";

    src = fetchFromGitHub {
      owner = "gitkraken";
      repo = "vscode-gitlens";
      tag = "v${finalAttrs.version}";
      hash = "sha256-VpHCSWa/XOKe0qxEdjnTManropO77n5YLFBZ647yWXw=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 5;
      hash = "sha256-DT+Hbj5eL7hd9nmsUAtMcOHCPp7ENIkiCE68oAmfS38=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    strictDeps = true;
    __structuredAttrs = true;

    postPatch = ''
      # Skip bundling the unit tests in quick mode: the bundle is not shipped in the vsix, and its esbuild step needs ~4 GiB of memory.
      substituteInPlace scripts/build.mjs \
        --replace-fail '`''${baseCmd} --config-name unit-tests`,' \
          '...(quick ? [] : [`''${baseCmd} --config-name unit-tests`]),'

      # Run the webpack bundles sequentially: they share the dist/ output directory and race on cleaning it (ENOTEMPTY).
      substituteInPlace scripts/build.mjs \
        --replace-fail 'const tasks = bundleCmds.map(c => run(c));' \
          'const tasks = []; for (const c of bundleCmds) { tasks.push(await run(c)); }'
    '';

    # Remove sass-embedded from sass-loader's dependency resolution so that it falls back to the pure-JS `sass` implementation.
    preBuild = ''
      for link in "$STORE_PATH"/v11/links/@/sass-loader/*/*/node_modules/sass-embedded; do
        [ -L "$link" ] || continue
        rm "$link"
      done
    '';

    buildPhase = ''
      runHook preBuild

      node --run bundle:quick
      GL_SKIP_BUNDLE=true node --run package

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp ./gitlens-$version.vsix $out

      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "gitlens";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "eamodio";
  vscodeExtName = "gitlens";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.eamodio.gitlens.vsix";
    };
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
    description = "Visual Studio Code extension that improves its built-in Git capabilities";
    longDescription = ''
      Supercharge the Git capabilities built into Visual Studio Code — Visualize code authorship at a glance via Git
      blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via
      powerful comparison commands, and so much more
    '';
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens";
    homepage = "https://gitlens.amod.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      ratsclub
    ];
  };
})
