{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "copyright-update";
  version = "2025.0404";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jaalto";
    repo = "project--copyright-update";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-FeKWCgCDA77iJ/cWtfx6hXSyWxwmlkW4EidPxy1W9VY=";
  };

  buildInputs = [ perl ];

  installFlags = [
    "INSTALL=install"
    "prefix=$(out)"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/jaalto/project--copyright-update";
    changelog = "https://github.com/jaalto/project--copyright-update/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Updates the copyright information in a set of files";
    mainProgram = "copyright-update";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
