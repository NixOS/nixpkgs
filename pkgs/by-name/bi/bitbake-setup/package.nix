{
  lib,
  python3Packages,
  fetchPypi,

  git,

  nix-update-script,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bitbake-setup";
  version = "2.19.0";
  format = "wheel";

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "bitbake_setup";
    inherit (finalAttrs) version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-tq53r8I02HL4mTgnIxcVf4VTYhRngYgl232/cDgLzdI=";
  };

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ git ])
  ];

  pythonImportsCheck = [ "bitbake_setup" ];

  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "mirror://pypi/b/bitbake_setup/"
    ];
  };

  meta = {
    description = "Command that sets up a BitBake build environment from a published configuration";
    homepage = "https://git.openembedded.org/bitbake/";
    downloadPage = "https://pypi.org/project/bitbake-setup/";
    license = with lib.licenses; [
      gpl2Only
      mit
      psfl
      zlib
      lgpl21Plus
      bsd3Clear
    ];
    mainProgram = "bitbake-setup";
    maintainers = with lib.maintainers; [ otavio ];
    platforms = lib.platforms.linux;
  };
})
