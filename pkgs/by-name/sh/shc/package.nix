{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shc";
  version = "4.0.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "neurobin";
    repo = "shc";
    tag = finalAttrs.version;
    hash = "sha256-JJmOZ8blcCGJjrR4q4FrA3da9KBpJoRJUFpregkg1i0=";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/neurobin/shc";
    changelog = "https://github.com/neurobin/shc/releases/tag/${finalAttrs.src.tag}";
    description = "Shell Script Compiler";
    mainProgram = "shc";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
  };
})
