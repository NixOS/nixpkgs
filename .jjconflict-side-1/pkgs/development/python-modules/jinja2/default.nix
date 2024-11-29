{
  lib,
  stdenv,
  python,
  pythonAtLeast,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  babel,
  markupsafe,
  pytestCheckHook,
  sphinxHook,
  pallets-sphinx-themes,
  sphinxcontrib-log-cabinet,
  sphinx-issues,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "jinja2";
  version = "3.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sjruesu+cwOu3o6WSNE7i/iKQpKCqmEiqZPwrIAMs2k=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ markupsafe ];

  optional-dependencies = {
    i18n = [ babel ];
  };

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.hostPlatform.is32bit;

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.i18n;

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/pallets/jinja/issues/1900
    "test_custom_async_iteratable_filter"
    "test_first"
    "test_loop_errors"
    "test_package_zip_list"
  ];

  passthru.doc = stdenv.mkDerivation {
    # Forge look and feel of multi-output derivation as best as we can.
    #
    # Using 'outputs = [ "doc" ];' breaks a lot of assumptions.
    name = "${pname}-${version}-doc";
    inherit src pname version;

    patches = [
      # Fix import of "sphinxcontrib-log-cabinet"
      ./patches/import-order.patch
    ];

    postInstallSphinx = ''
      mv $out/share/doc/* $out/share/doc/python$pythonVersion-$pname-$version
    '';

    nativeBuildInputs = [
      sphinxHook
      sphinxcontrib-log-cabinet
      pallets-sphinx-themes
      sphinx-issues
    ];

    inherit (python) pythonVersion;
    inherit meta;
  };

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    changelog = "https://github.com/pallets/jinja/blob/${version}/CHANGES.rst";
    description = "Very fast and expressive template engine";
    downloadPage = "https://github.com/pallets/jinja";
    homepage = "https://jinja.palletsprojects.com";
    license = licenses.bsd3;
    longDescription = ''
      Jinja is a fast, expressive, extensible templating engine. Special
      placeholders in the template allow writing code similar to Python
      syntax. Then the template is passed data to render the final document.
    '';
    maintainers = with maintainers; [ pierron ];
  };
}
