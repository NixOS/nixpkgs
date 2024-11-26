{
  buildPythonPackage,
  click,
  fetchPypi,
  lib,
  nix-update-script,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "click-odoo";
  version = "1.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zyfgsHzIoz4lnqANe63b2oqgD/oxBbTbJYEedfSHWQ8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ click ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Odoo scripting helper library";
    mainProgram = "click-odoo";
    homepage = "https://github.com/acsone/click-odoo";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
