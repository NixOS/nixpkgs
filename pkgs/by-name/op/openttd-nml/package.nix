{
  lib,
  fetchFromGitHub,
  python3,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "openttd-nml";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    tag = finalAttrs.version;
    hash = "sha256-swAkUhduIhcfbAvKsPaJNBXcv8T6GDaxk3KKLLa9GQ8=";
  };

  postPatch = ''
    echo 'version = "${finalAttrs.version}"' > nml/__version__.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pillow
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/OpenTTD/nml/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/OpenTTD/nml";
    description = "Compiler for OpenTTD NML files";
    mainProgram = "nmlc";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
  };
})
