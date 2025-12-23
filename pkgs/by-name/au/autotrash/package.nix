{
  lib,
  python3Packages,
  fetchFromGitHub,
  pandoc,
  installShellFiles,
}:

python3Packages.buildPythonPackage rec {
  pname = "autotrash";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bneijt";
    repo = "autotrash";
    tag = version;
    hash = "sha256-qMU3jjBL5+fd9vKX5BIqES5AM8D/54aBOmdHFiBtfEo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ python3Packages.poetry-core ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postBuild = "make -C doc autotrash.1";

  postInstall = "installManPage doc/autotrash.1";

  pythonImportsCheck = [ "autotrash" ];
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = {
    description = "Tool to automatically purge old trashed files";
    license = lib.licenses.gpl3Plus;
    homepage = "https://bneijt.nl/pr/autotrash";
    changelog = "https://github.com/bneijt/autotrash/releases/tag/${version}";
    maintainers = with lib.maintainers; [
      sigmanificient
      mithicspirit
    ];
    mainProgram = "autotrash";
  };
}
