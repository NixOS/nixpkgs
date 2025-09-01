{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surgescript";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "surgescript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m6H9cyoUY8Mgr0FDqPb98PRJTgF7DgSa+jC+EM0TDEw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "surgescript";
    description = "Scripting language for games";
    homepage = "https://docs.opensurge2d.org/";
    downloadPage = "https://github.com/alemart/surgescript";
    changelog = "https://github.com/alemart/surgescript/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
