{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "sigparse";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lunarmagpie";
    repo = "sigparse";
    tag = "v${version}";
    hash = "sha256-VzWDqplYgwrJXXd5IUzEIp0YRuofybqmGrNKPaGqQFM=";
  };

  patches = [
    # pyproject.toml version file is set as 1.0.0
    (fetchpatch {
      url = "https://github.com/Lunarmagpie/sigparse/pull/14/commits/44780382410bc6913bdd8ff7e92948078adb736c.patch";
      hash = "sha256-3EOkdBQDBodMBp4ENdvquJlRvAAywQhdWAX4dWFmhL0=";
    })
  ];

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "sigparse" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Backports python 3.10 typing features into 3.7, 3.8, and 3.9";
    license = lib.licenses.mit;
    homepage = "https://github.com/Lunarmagpie/sigparse";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
