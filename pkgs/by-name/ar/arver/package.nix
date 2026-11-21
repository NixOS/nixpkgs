{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  libsndfile,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "arver";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arcctgx";
    repo = "ARver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bIvjZ2fR/JeEXMVYOgAP2XkwFXn/zzS3hFz/5cgkuJg=";
  };

  nativeBuildInputs = [
    gobject-introspection
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    discid
    musicbrainzngs
    pycdio
    requests
  ];

  buildInputs = [ libsndfile ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  nativeCheckInputs = [ python3Packages.unittestCheckHook ];
  unittestFlags = [
    "-s"
    "tests"
    "-v"
    "-p"
    "*_test.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/arcctgx/ARver";
    description = "Application for verifying CD rips using AccurateRip database";
    maintainers = with lib.maintainers; [ Cameo007 ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "arver";
  };
})
