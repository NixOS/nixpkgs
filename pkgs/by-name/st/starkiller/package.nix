{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  nodejs_24,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "starkiller";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "bc-security";
    repo = "starkiller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KjEHbRhbXY57886uziRzUoA/MzK6QZx7/b1lrmIKsWc=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-fkpYRnBEM/nUtdqnWMb7Trqa5SnCrdX7RUYgd73RGFE=";
  };

  buildPhase = ''
    runHook preBuild

    # Copying the workaround from
    # https://github.com/NixOS/nixpkgs/pull/386706
    pushd node_modules/vue-demi
    yarn run postinstall
    popd

    yarn --offline build

    runHook postBuild
  '';

  postInstall = ''
    mkdir $out
    cp -r dist/** $out
  '';

  nativeBuildInputs = [
    yarnConfigHook
    # Needed for executing package.json scripts
    nodejs_24
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/BC-SECURITY/Starkiller";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    description = "Web UI for Empire";
    maintainers = with lib.maintainers; [
      fzakaria
      vrose
    ];
  };
})
