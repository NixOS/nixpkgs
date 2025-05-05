{
  fetchFromGitHub,
  gitUpdater,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ubi_reader";
  version = "0.8.10";
  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "ubi_reader";
    rev = "v${version}";
    hash = "sha256-fXJiQZ1QWUmkRM+WI8DSIsay9s1w3hKloRuCcUNwZjM=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = [ python3.pkgs.lzallright ];

  # There are no tests in the source
  doCheck = false;

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "_[a-z]+$";
    };
  };

  meta = {
    description = "Python scripts capable of extracting and analyzing the contents of UBI and UBIFS images";
    homepage = "https://github.com/onekey-sec/ubi_reader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
