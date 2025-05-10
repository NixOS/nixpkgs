{
  lib,
  python3,
  fetchFromGitHub,
  beancount,
  beancount-plugin-utils,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beancount_share";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "akuukis";
    repo = "beancount_share";
    rev = "v${version}";
    sha256 = "sha256-BW2KEC0pmervT71FBixPcQciEuGcElCd2wW7BZL1xUg=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
    beancount
    beancount-plugin-utils
  ];

  buildInputs = [
    python3.pkgs.setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/akuukis/beancount_share";
    description = "Beancount plugin to share expenses with external partners within one ledger";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
