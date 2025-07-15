{
  lib,
  python3,
  fetchFromGitHub,
  beangulp,
  beancount,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beancount-ing-diba";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "beancount-ing-diba";
    rev = "v${version}";
    sha256 = "sha256-zjwajl+0ix4wnW0bf4MAuO9Lr9F8sBv87TIL5Ghmlxg=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
    beancount
    beangulp
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  meta = with lib; {
    homepage = "https://github.com/siddhantgoel/beancount-ing-diba";
    description = "Beancount Importers for ING-DiBa (Germany) CSV Exports";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
