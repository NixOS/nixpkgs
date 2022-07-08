{ lib
, python3
, fetchPypi
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "whoogle-search";
  version = "0.8.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r/DrI1xugKU3pxTA/5h2Oo9ubyVngZSVQmswbqOq3uQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    attrs
    brotli
    cachelib
    certifi
    certifi
    chardet
    click
    idna
    itsdangerous
    jinja2
    markupsafe
    more-itertools
    packaging
    pluggy
    pycparser
    pyopenssl
    pyparsing
    pysocks
    python-dateutil
    soupsieve
    wcwidth
    werkzeug
    python-dotenv
    beautifulsoup4
    cssutils
    cryptography
    defusedxml
    flask
    python-dotenv
    requests
    stem
    waitress
  ];

  pythonRemoveDeps = [
    "pytest"
    "pycodestyle"
  ];

  postInstall = ''
    mv $out/${python3.sitePackages}/app/static $out/${python3.sitePackages}/app/static_runtime

    # FIXME: Is it possible to specify dataDir from service configuration here?
    ln -s /var/lib/whoogle-search/static $out/${python3.sitePackages}/app/static
  '';

  # Require network
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) whoogle-search;
  };

  meta = {
    homepage = "https://github.com/benbusby/whoogle-search";
    description = "A self-hosted, ad-free, privacy-respecting metasearch engine";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ seberm ];
  };
}
