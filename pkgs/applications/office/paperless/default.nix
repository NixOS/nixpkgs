{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, callPackage

, python3
, imagemagick7
, ghostscript
, optipng
, tesseract
, unpaper
}:

## Usage

# ${paperless}/bin/paperless wraps manage.py

# ${paperless}/share/paperless/setup-env.sh can be sourced from a
# shell script to setup a Paperless environment

# paperless.withConfig is a convenience function to setup a
# configured Paperless instance. (See ./withConfig.nix)

# For WSGI with gunicorn, use a shell script like this:
# let
#   pythonEnv = paperless.python.withPackages (ps: paperless.runtimePackages ++ [ ps.gunicorn ]);
# in
#   writers.writeBash "run-gunicorn" ''
#     source ${paperless}/share/paperless/setup-env.sh
#     PYTHONPATH=$paperlessSrc ${pythonEnv}/bin/gunicorn paperless.wsgi
#   ''

let
  paperless = stdenv.mkDerivation rec {
    pname = "paperless";
    version = "2.7.0";

    src = fetchFromGitHub {
      owner = "the-paperless-project";
      repo = "paperless";
      rev = version;
      sha256 = "0pkmyky1crjnsg7r0gfk0fadisfsgzlsq6afpz16wx4hp6yvkkf7";
    };

    nativeBuildInputs = [ makeWrapper ];

    doCheck = true;
    dontInstall = true;

    pythonEnv      = python.withPackages (_: runtimePackages);
    pythonCheckEnv = python.withPackages (_: (runtimePackages ++ checkPackages));

    unpackPhase = ''
      srcDir=$out/share/paperless
      mkdir -p $srcDir
      cp -r --no-preserve=mode $src/src/* $src/LICENSE $srcDir
    '';

    postPatch = ''
      # django-cors-headers 3.x requires a scheme for allowed hosts
      substituteInPlace $out/share/paperless/paperless/settings.py \
        --replace "localhost:8080" "http://localhost:8080"
    '';

    buildPhase = let
      # Paperless has explicit runtime checks that expect these binaries to be in PATH
      extraBin = lib.makeBinPath [ imagemagick7 ghostscript optipng tesseract unpaper ];
    in ''
      ${python.interpreter} -m compileall $srcDir

      makeWrapper $pythonEnv/bin/python $out/bin/paperless \
        --set PATH ${extraBin} --add-flags $out/share/paperless/manage.py

      # A shell snippet that can be sourced to setup a paperless env
      cat > $out/share/paperless/setup-env.sh <<EOF
      export PATH="$pythonEnv/bin:${extraBin}''${PATH:+:}$PATH"
      export paperlessSrc=$out/share/paperless
      EOF
    '';

    checkPhase = ''
      source $out/share/paperless/setup-env.sh
      tmpDir=$(realpath testsTmp)
      mkdir $tmpDir
      export HOME=$tmpDir
      export PAPERLESS_MEDIADIR=$tmpDir
      cd $paperlessSrc
      # Prevent tests from writing to the derivation output
      chmod -R -w $out
      # Disable cache to silence a pytest warning ("could not create cache")
      $pythonCheckEnv/bin/pytest -p no:cacheprovider
    '';

    passthru = {
      withConfig = callPackage ./withConfig.nix {};
      inherit python runtimePackages checkPackages tesseract;
    };

    meta = with lib; {
      description = "Scan, index, and archive all of your paper documents";
      homepage = https://github.com/the-paperless-project/paperless;
      license = licenses.gpl3;
      maintainers = [ maintainers.earvstedt ];
    };
  };

  python = python3.override {
    packageOverrides = self: super: {
      # Paperless only supports Django 2.0
      django = django_2_0 super;
      pyocr = pyocrWithUserTesseract super;
      # These are pre-release versions, hence they are private to this pkg
      django-filter = self.callPackage ./python-modules/django-filter.nix {};
      django-crispy-forms = self.callPackage ./python-modules/django-crispy-forms.nix {};
    };
  };

  django_2_0 = pyPkgs: pyPkgs.django_2_2.overrideDerivation (_: rec {
    pname = "Django";
    version = "2.0.12";
    name = "${pname}-${version}";
    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "15s8z54k0gf9brnz06521bikm60ddw5pn6v3nbvnl47j1jjsvwz2";
    };
  });

  runtimePackages = with python.pkgs; [
    dateparser
    dateutil
    django
    django-cors-headers
    django-crispy-forms
    django-filter
    django_extensions
    djangoql
    djangorestframework
    factory_boy
    filemagic
    fuzzywuzzy
    langdetect
    pdftotext
    pillow
    psycopg2
    pyocr
    python-dotenv
    python-gnupg
    pytz
    termcolor
  ] ++ (lib.optional stdenv.isLinux inotify-simple);

  checkPackages = with python.pkgs; [
    pytest
    pytest-django
    pytest-env
    pytest_xdist
  ];

  pyocrWithUserTesseract = pyPkgs:
    let
      pyocr = pyPkgs.pyocr.override { inherit tesseract; };
    in
      if pyocr.outPath == pyPkgs.pyocr.outPath then
        pyocr
      else
        # The user has provided a custom tesseract derivation that might be
        # missing some languages that are required for PyOCR's tests. Disable them to
        # avoid build errors.
        pyocr.overridePythonAttrs (attrs: {
          doCheck = false;
        });
in
  paperless
