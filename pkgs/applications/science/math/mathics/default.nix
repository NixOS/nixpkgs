{ lib, fetchFromGitHub, buildPythonApplication, isPy3k
, sympy, numpy, pint, django_3, mpmath, dateutil, llvmlite, requests
, palettable, setuptools, wordcloud, scikitimage, python
}:

let
  deps = [
    sympy numpy pint django_3 mpmath dateutil llvmlite requests
    palettable setuptools wordcloud scikitimage
  ];
  pythonEnv = python.withPackages (p: deps);
in
  buildPythonApplication rec {
    pname = "mathics";
    version = "1.1.1";

    src = fetchFromGitHub {
      owner = "mathics";
      repo = "Mathics";
      rev = version;
      sha256 = "sha256-6VCz/pd2kRUkezCoXjqvPYhbzHojHQZ7y//NAFrPHas=";
    };

    propagatedBuildInputs = deps;

    postPatch = ''
      substituteInPlace mathics/server.py \
        --replace "sys.executable, " ""
    '';

    # We run tests at the `postInstall` stage. This also installs documentation.
    doCheck = false;

    postInstall = ''
      rm $out/bin/dmathics*

      # the purpose of the following command is to generate documentation
      SANDBOX=true python mathics/test.py --keep-going

      for manage in $(find $out -name manage.py); do
        chmod +x $manage
        wrapProgram $manage --set PYTHONPATH "$PYTHONPATH:${pythonEnv}/${pythonEnv.sitePackages}"
      done
    '';

    disabled = !isPy3k;
    meta = with lib; {
      description = "A free, light-weight alternative to Mathematica";
      homepage = "https://mathics.github.io/";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ suhr ];
    };
  }
