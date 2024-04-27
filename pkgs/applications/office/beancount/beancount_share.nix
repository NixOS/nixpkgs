{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beancount_share";
  version = "2023-12-31";

  src = fetchFromGitHub {
    owner = "akuukis";
    repo = "beancount_share";
    rev = "8f925422b9947e88babbeab3fdf7d71c53c9aa9e";
    sha256 = "sha256-+ZA84VS0wf9TdrYleYB5OeKz7T8sDtrl4BM7Ft+k7OI=";
  };

  format = "pyproject";

  buildInputs = [
    python3.pkgs.setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/akuukis/beancount_share";
    description = "A beancount plugin to share expenses with external partners within one ledger";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
