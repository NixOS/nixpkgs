{ stdenv, pkgs, fetchurl, python3Packages, fetchFromGitHub, fetchzip, python3, beancount }:

python3Packages.buildPythonApplication rec {
  version = "1.3";
  name = "fava-${version}";

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "fava";
    rev = "v${version}";
    sha256 = "0g0aj0qcmpny6dipi00nks7h3mf5a4jfd6bxjm1rb5807wswcpg8";
  };

  assets = fetchzip {
    url = "https://github.com/beancount/fava/releases/download/v${version}/fava-${version}.tar.gz";
    sha256 = "0yn2psbn436g1w5ixn94z8ca6dfd54izg98979arn0k7slpiccvz";
  };

  buildInputs = with python3Packages; [ pytest_30 ];

  checkPhase = ''
    # pyexcel is optional
    # the other 2 tests fail due non-unicode locales
    PATH=$out/bin:$PATH pytest tests \
      --ignore tests/test_util_excel.py \
      --ignore tests/test_cli.py \
      --ignore tests/test_translations.py \
  '';

  postInstall = ''
    cp -r $assets/fava/static/gen $out/${python3.sitePackages}/fava/static
  '';

  propagatedBuildInputs = with python3Packages;
    [ flask dateutil pygments wheel markdown2 flaskbabel tornado
      click beancount ];

  meta = {
    homepage = https://github.com/aumayr/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

