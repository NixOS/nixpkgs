{ stdenv, pkgs, fetchurl, python3Packages, fetchFromGitHub, fetchzip, python3 }:

let

  # We're building beancount here as dependency-only package because fava 0.3.0
  # depends on beancount-2.0b2, but beancount as in pkgs.beancount is from the
  # master branch of the beancount repository (as the maintainer does not
  # release versions).
  beancount = python3Packages.buildPythonPackage rec {
    version = "2.0b12";
    name = "beancount-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/beancount/${name}.tar.gz";
      sha256 = "0n0wyi2yhmf8l46l5z68psk4rrzqkgqaqn93l0wnxsmp1nmqly9z";
    };

    buildInputs = with python3Packages; [ nose ];

    # Automatic tests cannot be run because it needs to import some local modules for tests.
    doCheck = false;
    checkPhase = ''
      nosetests
    '';

    propagatedBuildInputs = with python3Packages; [
      beautifulsoup4
      bottle
      chardet
      dateutil
      google_api_python_client
      lxml
      ply
      python_magic
    ];

    meta = {
      homepage = http://furius.ca/beancount/;
      description = "Double-entry bookkeeping computer language";
      longDescription = ''
          A double-entry bookkeeping computer language that lets you define
          financial transaction records in a text file, read them in memory,
          generate a variety of reports from them, and provides a web interface.
      '';
      license = stdenv.lib.licenses.gpl2;
      maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
    };
  };

in
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

