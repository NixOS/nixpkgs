{
  lib,
  python3,
  fetchPypi,
  nginx,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gixy-ng";
  version = "0.2.47";
  pyproject = true;

  src = fetchPypi {
    pname = "gixy_ng";
    inherit version;
    hash = "sha256-Zyn0rmskzlVJJbzlHLvKnlF4XDGi+FuSODTEDI0gDdE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    ngxparse
    jinja2
    configargparse
  ];

  pythonImportsCheck = [ "gixy" ];

  # The pytest suite needs fixtures that don't ship in the PyPI sdist;
  # the import check above is the smoke test.
  doCheck = false;

  passthru = {
    inherit (nginx.passthru) tests;
  };

  meta = {
    description = "Nginx configuration static analyzer focused on security";
    mainProgram = "gixy";
    longDescription = ''
      Gixy is a static analyzer for nginx configurations. Its main
      goal is to detect security misconfigurations and to automate
      the discovery of common flaws (HTTP response splitting, host
      spoofing on virtual-host dispatch, alias-traversal "off-by-
      slash", missing add_header inheritance, weak SSL/TLS ciphers,
      and more).

      Tracks the actively-maintained gixy-ng distribution on PyPI;
      the binary remains `gixy'.
    '';
    homepage = "https://gixy.getpagespeed.com/";
    changelog = "https://github.com/dvershinin/gixy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dvershinin ];
    platforms = lib.platforms.unix;
  };
}
