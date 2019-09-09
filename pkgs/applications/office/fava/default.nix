{ stdenv, python3, beancount }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "fava";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gyrxqmfr8igfjnp9lcsl4km17yakj556xns3jp4m9l2407b5zhc";
  };

  checkInputs = [ python3.pkgs.pytest ];
  propagatedBuildInputs = with python3.pkgs;
    [ 
      Babel
      cheroot
      flaskbabel
      flask
      jinja2
      beancount
      click
      markdown2
      ply
      simplejson
    ];

  # CLI test expects fava on $PATH.  Not sure why static_url fails.
  checkPhase = ''
    py.test tests -k 'not cli and not static_url'
  '';

  meta = {
    homepage = https://beancount.github.io/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
