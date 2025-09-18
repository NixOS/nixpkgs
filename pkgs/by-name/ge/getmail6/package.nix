{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.19.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getmail6";
    repo = "getmail6";
    tag = "v${version}";
    hash = "sha256-W9B6+riHsE5Hu2J8QnhPKhpRlXsQyg3ThP4ADp/0UhI=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  # needs a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "getmailcore" ];

  postPatch = ''
    # getmail spends a lot of effort to build an absolute path for
    # documentation installation; too bad it is counterproductive now
    sed -e '/datadir or prefix,/d' -i setup.py
    sed -e 's,/usr/bin/getmail,$(dirname $0)/getmail,' -i getmails
  '';

  meta = with lib; {
    description = "Program for retrieving mail";
    homepage = "https://getmail6.org";
    changelog = "https://github.com/getmail6/getmail6/blob/${src.tag}/docs/CHANGELOG";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      abbe
      dotlambda
    ];
  };
}
