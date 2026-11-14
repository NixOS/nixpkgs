{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:

let
  # upstream's `packageManager` is pnpm@11.x
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "acpx";
  version = "0.21.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "acpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NUmbOZtOSK6drpydUwP1eNnAXmOJ4U/3J0i1AiBQPlc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-ytuCMbViFnP/LOvgKDxxXXgXdMQ0/PcakESoyHg5Wdk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  # `prepack` rebuilds with tsdown, a devDependency that `pnpm prune --prod` already removed;
  # `dist` is built in buildPhase.
  npmPackFlags = [ "--ignore-scripts" ];

  dontNpmPrune = true;

  # `bare-*` (dependencies of tar-stream) are only loaded under the Bare runtime, via the
  # "bare" import condition, and ship prebuilt addons for every OS (win32, android, ios, ...)
  # that are dead weight under Node.
  postInstall = ''
    find $out/lib/node_modules/acpx/node_modules/.pnpm \
      -type d -path '*/node_modules/bare-*/prebuilds' -prune -exec rm -r {} +
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Headless CLI client for the Agent Client Protocol (ACP), to drive coding agents without an editor";
    homepage = "https://github.com/openclaw/acpx";
    changelog = "https://github.com/openclaw/acpx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "acpx";
    maintainers = with lib.maintainers; [ ismailkattakath ];
  };
})
