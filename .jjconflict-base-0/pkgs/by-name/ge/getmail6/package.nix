{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.19.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getmail6";
    repo = "getmail6";
    rev = "refs/tags/v${version}";
    hash = "sha256-GjB53bl2gh3SA+kqC9rrQ9I4rP0z69G/bamInmq8W+I=";
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
    changelog = "https://github.com/getmail6/getmail6/blob/${src.rev}/docs/CHANGELOG";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      abbe
      dotlambda
    ];
  };
}
