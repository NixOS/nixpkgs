{ lib
, python3
, fetchFromGitHub
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = "v${version}";
    hash = "sha256-OUwznn71xl8oWkw90fT1NYYZOuD83k+B5zLhygp1VQQ=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    passlib
    vobject
    pika
    python-dateutil
    pytz # https://github.com/Kozea/Radicale/issues/816
  ] ++ passlib.optional-dependencies.bcrypt;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    pytest7CheckHook
    waitress
  ];

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = with lib; {
    homepage = "https://radicale.org/v3.html";
    changelog = "https://github.com/Kozea/Radicale/blob/${src.rev}/CHANGELOG.md";
    description = "CalDAV and CardDAV server";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda erictapen ];
  };
}
