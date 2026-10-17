{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs-slim,
  makeBinaryWrapper,
  git,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dotagents";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "dotagents";
    tag = finalAttrs.version;
    hash = "sha256-EnVCH0tKCUEcKu+CvkOgc3y9QM0k3rPeJbJ6qcfXVhI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  pnpmWorkspaces = [ "@sentry/dotagents..." ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-eDumJk2N7z5tvfvAkOWFUr1zZhaBQbA+yGtBf3OEKXg=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "@sentry/dotagents..." build

    runHook postBuild
  '';

  preInstall = ''
    rm -rf node_modules packages/*/node_modules
    pnpm install \
      --offline \
      --ignore-scripts \
      --filter="@sentry/dotagents..." \
      --frozen-lockfile \
      --prod
    find packages/*/dist -type f \( -name "*.d.ts" -o -name "*.map" \) -delete
    find node_modules packages/*/node_modules -xtype l -delete
    rm node_modules/.modules.yaml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/dotagents/packages}
    cp -r node_modules $out/lib/dotagents/
    for pkg in dotagents dotagents-lib; do
      mkdir -p $out/lib/dotagents/packages/$pkg
      cp -r packages/$pkg/{package.json,dist,node_modules} $out/lib/dotagents/packages/$pkg/
    done

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/dotagents \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
      --add-flags $out/lib/dotagents/packages/dotagents/dist/cli/index.js

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package manager for .agents directories";
    homepage = "https://github.com/getsentry/dotagents";
    changelog = "https://github.com/getsentry/dotagents/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "dotagents";
    platforms = nodejs-slim.meta.platforms;
  };
})
