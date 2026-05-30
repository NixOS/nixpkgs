{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iprange";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "firehol";
    repo = "iprange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/rNM/5SmqpNX/yM/9EZdRYsXxgbPLp7+SL/RDtKo3+0=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--disable-man" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Manage IP ranges";
    homepage = "https://github.com/firehol/iprange";
    changelog = "https://github.com/firehol/iprange/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "iprange";
  };
})
