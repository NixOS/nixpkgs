{ stdenv, pkgs, fetchurl, python3Packages, fetchFromGitHub, fetchzip, python3, beancount }:

python3Packages.buildPythonApplication rec {
  version = "1.0";
  name = "fava-${version}";

  src = fetchFromGitHub {
    owner = "aumayr";
    repo = "fava";
    rev = "v${version}";
    sha256 = "0dm4x6z80m04r9qa55psvz7f41qnh13hnj2qhvxkrk22yqmkqrka";
  };

  assets = fetchzip {
    url = "https://github.com/aumayr/fava/releases/download/v${version}/beancount-fava-${version}.tar.gz";
    sha256 = "1vvidwfn5882dslz6qqkkd84m7w52kd34x10qph8yhipyjv1dimc";
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

