{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iprange";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "firehol";
    repo = "iprange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmGJaDwduieMhYpNy3sunrTARgRMz24h/jT/cGSh14Y=";
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
