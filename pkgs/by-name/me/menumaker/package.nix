{
  lib,
  fetchurl,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "menumaker";
  version = "0.99.14";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/menumaker-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-EeldDnajuFD1ffgbxVYCIr1gFBxXUbbpvQXDzVVg1lo=";
  };

  pyproject = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Heuristics-driven menu generator for several window managers";
    mainProgram = "mmaker";
    homepage = "https://menumaker.sourceforge.net";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
})
