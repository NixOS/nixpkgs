{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  otf2,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "EZTrace";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    tag = finalAttrs.version;
    hash = "sha256-ccW4YjEf++tkdIJLze2x8B/SWbBBXnYt8UV9OH8+KGU=";
  };

  nativeBuildInputs = [
    cmake
    otf2
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    homepage = "https://eztrace.gitlab.io/eztrace/";
    changelog = "https://gitlab.com/eztrace/eztrace/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.cecill-b;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ ];
  };
})
