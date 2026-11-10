{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "svelte-check";
  version = "4.7.7";

  src = fetchFromGitHub {
    owner = "sveltejs";
    repo = "language-tools";
    tag = "svelte-check@${finalAttrs.version}";
    hash = "sha256-AJZj3dDvDG2PvT8YFRS0lEbnXckdZ1XX22j1phSc2Ig=";
  };

  pnpmWorkspaces = [ "svelte-check..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-OdPwM+IL2h90BIJdyBzpXx+Z9NT+zKfZoFYOrTsiaP0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm
    makeBinaryWrapper
  ];

  installPhase = ''
        runHook preInstall

    cp -rL packages/svelte-check/node_modules/svelte "$TMPDIR/svelte"
        rm -rf node_modules packages/*/node_modules
        pnpm install --filter=svelte-check... --prod --frozen-lockfile --offline --force --ignore-scripts
        cp -r "$TMPDIR/svelte" packages/svelte-check/node_modules/svelte

        mkdir -p $out/lib/node_modules/svelte-check/
        mkdir -p $out/bin

        mv {packages,node_modules} $out/lib/node_modules/svelte-check/

        makeWrapper ${lib.getExe nodejs} $out/bin/svelte-check \
          --add-flags "$out/lib/node_modules/svelte-check/packages/svelte-check/bin/svelte-check" \
          --set NODE_PATH "$out/lib/node_modules/svelte-check/packages/svelte-check/node_modules/"

        runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "svelte-check@(.*)"
    ];
  };

  meta = {
    description = "Svelte code checker";
    downloadPage = "https://www.npmjs.com/package/svelte-check";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelte-check";
    maintainers = with lib.maintainers; [ dfjay ];
  };
})
