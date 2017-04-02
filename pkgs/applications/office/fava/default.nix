{ stdenv, pkgs, fetchurl, python3Packages, fetchFromGitHub, fetchzip, python3, beancount }:

python3Packages.buildPythonApplication rec {
  version = "1.2";
  name = "fava-${version}";

  src = fetchurl {
    url = "https://github.com/beancount/fava/archive/v${version}.tar.gz";
    sha256 = "0sykx054w4cvr0pgbqph0lmkxffafl83k5ir252gl5znxgcvg6yw";
  };

  assets = fetchzip {
    url = "https://github.com/beancount/fava/releases/download/v${version}/beancount-fava-${version}.tar.gz";
    sha256 = "1lk6s3s6xvvwbcbkr1qpr9bqdgwspk3vms25zjd6xcs21s3hchmp";
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

