{ lib
, python3
, fetchFromGitHub
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = "v${version}-version";
    hash = "sha256-ZdcV2t2F2UgjGC+aTfynP2DbPRgzOIADDebY64nj3NA=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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
