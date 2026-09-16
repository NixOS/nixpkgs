{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gh,
  makeBinaryWrapper,
  nix-update-script,
  nodejs_24,
  stdenv,
  versionCheckHook,
  xdg-utils,
}:

buildNpmPackage (finalAttrs: {
  pname = "diffle";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "moritzwilksch";
    repo = "diffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CcI4EV2dVmZ8szR+IND8aq9UJu3zcje/6I6KTOg7tDk=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-IUN/Qf5urqSILfX+fwh/RjU6UZ0+i96/T/xBtx5FaVQ=";

  # `npm pack` would run the `prepack` build script a second time.
  npmPackFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    versionCheckHook
  ];

  # `diffle` shells out to `gh` for `diffle pr` and to a browser opener, which is
  # `xdg-open` on Linux and `open` on Darwin, where it ships with the system.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath ([ gh ] ++ lib.optional stdenv.hostPlatform.isLinux xdg-utils))
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local Git diff reviewer in the browser";
    homepage = "https://github.com/moritzwilksch/diffle";
    changelog = "https://github.com/moritzwilksch/diffle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ytausch ];
    mainProgram = "diffle";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
